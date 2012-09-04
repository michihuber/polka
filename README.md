# Polka
Polka sets up your dotfiles

## Usage
    gem install polka

In your dotfile directory create a file called `Dotfile`. My Dotfile looks like this:

    configure personal_file: "~/Dropbox/polka_personal.yml"

    symlink ".gemrc", ".vimrc", ".zshrc", ".zsh_custom", ".vim"
    symlink ".gitignore_global", as: ".gitignore"
    copy ".gitconfig.erb"

Once you are done, run `polka setup`. Existing files will be moved to a backup dir.

You can avoid name collisions in your .dotfile directory by using the `:as` option.

`.erb`-files are parsed before they are copied: Create a `personal.yml` where you list your personal information that you may not want to check into your git repo (e.g. API tokens, name, email etc.):

    .gitconfig:
      name: Peter Venkman
      email: peter@ghostbusters.test

In `.gitconfig.erb`:

    [user]
      name = <%= personal['name'] %>
      email = <%= personal['email'] %>

`personal.yml` is expected to be in your dotfile directory and should be added to your `.gitignore`, ldo. Alternatively, you can configure an alternate path (see example).
