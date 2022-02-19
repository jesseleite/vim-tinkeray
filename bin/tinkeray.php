<?php

class TinkerayOutputException extends Exception {}

function getReturnFromIncludeOrFail($filename) {
    $php = str_replace('<?php', '', file_get_contents($filename));
    $php .= PHP_EOL.'throw new TinkerayOutputException;';

    return eval($php);
}

try {
    ray(getReturnFromIncludeOrFail(getenv('TINKERAY_APP_PATH')));
} catch (Throwable $t) {
    if ($t instanceof TinkerayOutputException) {
        ray('Warning: No `return` detected in [tinkeray.php]!')->orange();
    } else {
        ray()->exception($t);
    }
}

exit;
