<?php

function generateAst($filename)
{
    $code = file_get_contents($filename);
    $parser = (new PhpParser\ParserFactory())->create(PhpParser\ParserFactory::PREFER_PHP7);
    return $parser->parse($code);
}

function removeCommentLines($ast)
{
    $traverser = new PhpParser\NodeTraverser();
    $traverser->addVisitor(new class () extends PhpParser\NodeVisitorAbstract {
        public function leaveNode(PhpParser\Node $node)
        {
            if ($node instanceof PhpParser\Node\Stmt\Nop) {
                return PhpParser\NodeTraverser::REMOVE_NODE;
            }
        }
    });

    return $traverser->traverse($ast);
}

function enforceReturn($ast)
{
    $lastStmt = array_pop($ast);

    switch ($lastStmt->getType()) {
        case 'Stmt_Expression':
            $ast[] = new PhpParser\Node\Stmt\Return_($lastStmt->expr);
            break;
        case 'Stmt_Return':
        case 'Stmt_Echo':
        default:
            $ast[] = $lastStmt;
    }

    return $ast;
}

function evaluateTinkerFile($filename)
{
    $ast = enforceReturn(removeCommentLines(generateAst($filename)));
    $executionCode = (new PhpParser\PrettyPrinter\Standard())->prettyPrint($ast);

    return eval($executionCode);
}

try {
    ray(evaluateTinkerFile(getenv('TINKERAY_APP_PATH') . '/tinkeray.php'));
} catch (Throwable $t) {
    ray()->exception($t);
}

exit;
