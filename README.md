# Tinkeray

Heavily inspired by the absolutely awesome [Tinkerwell](https://tinkerwell.app/), run Laravel `artisan tinker` from a Vim buffer with output in [Ray](https://spatie.be/products/ray) 🖤

## Installation

1. Install using [vim-plug](https://github.com/junegunn/vim-plug) or similar:

    ```vim
    Plug 'jesseleite/vim-tinkeray'
    ```

2. Add `tinkeray.php` to your [global git excludes](https://gist.github.com/subfuzion/db7f57fff2fb6998a16c) file.

3. Add Tinkeray's mapping to stub and/or open a blank `tinkeray.php` in your project when you want to tinker:

    ```vim
    nmap <Leader>t <Plug>TinkerayOpen
    ```

## Usage

1. Install Ray into your project:

    ```bash
    composer require spatie/laravel-ray
    ```

2. Open the [Ray](https://spatie.be/products/ray) desktop app.

3. Run `:TinkerayOpen` (or activate the above mentioned mapping) to stub out and/or open a blank `tinkeray.php` file in your project when you want to tinker.

4. When you save `tinkeray.php`, you should see your returned output in Ray.

5. Order pizza! 🍕 🤘 😎

## Todo

- Figure out how to run as async job in Neovim

## Thank You!

- [Spatie](https://spatie.be/) and [BeyondCode](https://beyondco.de/) for rad tooling!
- [Jose Soto](https://twitter.com/josecanhelp) for contributions, slick ideas, and teamwork!

![](https://media.giphy.com/media/BvsKJXGzqfNPq/giphy.gif)
