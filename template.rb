require "fileutils"
require "shellwords"

# Copied from: https://github.com/mattbrictson/rails-template
# Add this template directory to source_paths so that Thor actions like
# copy_file and template resolve against our source files. If this file was
# invoked remotely via HTTP, that means the files are not present locally.
# In that case, use `git clone` to download them to a local temporary dir.
def add_template_repository_to_source_path
  if __FILE__ =~ %r{\Ahttps?://}
    require "tmpdir"
    source_paths.unshift(tempdir = Dir.mktmpdir("vine-"))
    at_exit { FileUtils.remove_entry(tempdir) }
    git clone: [
      "--quiet",
      "https://github.com/bmartel/vine.git",
      tempdir
    ].map(&:shellescape).join(" ")

    if (branch = __FILE__[%r{vine/(.+)/template.rb}, 1])
      Dir.chdir(tempdir) { git checkout: branch }
    end
  else
    source_paths.unshift(File.dirname(__FILE__))
  end
end

def stop_spring
  run "spring stop"
end

def add_hotwire
  rails_command "hotwire:install"
end

def add_action_text
  rails_command "action_text:install"
end

def add_users
  # Install Devise
  generate "devise:install"
  generate "devise_invitable:install"

  # Install Pundit policies
  generate "pundit:install"

  # Configure Devise
  environment "config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }",
              env: 'development'

  # Create Devise User
  generate :devise, "User"
  generate :devise_invitable, "User"

  generate "migration devise_changes_to_users"

  # Add additional user migrations
  devise_changes = Dir["db/migrate/**/*devise_changes_to_users.rb"].first
  insert_into_file devise_changes, after: "  def change\n" do
    <<-'RUBY'
    add_column :users, :display_name, :string
    add_column :users, :avatar_url, :string

    ## Confirmable
    add_column :users, :confirmation_token, :string
    add_column :users, :confirmed_at, :datetime
    add_column :users, :confirmation_sent_at, :datetime
    add_column :users, :unconfirmed_email, :string

    ## Lockable
    add_column :users, :failed_attempts, :integer, default: 0, null: false
    add_column :users, :unlock_token, :string
    add_column :users, :locked_at, :datetime

    ## Admin
    add_column :users, :admin, :boolean, default: false

    add_index :users, :confirmation_token,   unique: true
    add_index :users, :unlock_token,         unique: true
    RUBY
  end

  requirement = Gem::Requirement.new("> 6.0")
  rails_version = Gem::Version.new(Rails::VERSION::STRING)

  if requirement.satisfied_by? rails_version
    gsub_file "config/initializers/devise.rb",
      /  # config.secret_key = .+/,
      "  config.secret_key = Rails.application.credentials.secret_key_base"
  end
end

def copy_templates
  directory "app", force: true
  directory "config", force: true
  directory "lib", force: true
  directory "docker", force: true
  copy_file "Dockerfile", force: true
  copy_file ".dockerignore", force: true
  copy_file "postcss.config.js", force: true
  copy_file "tailwind.config.js", force: true
  copy_file ".prettierrc", force: true
  copy_file ".editorconfig", force: true
  copy_file "Procfile"
  run 'chmod +x docker/start.sh'
end

def add_npm_packages
  run 'yarn add tailwindcss@yarn:@tailwindcss/postcss7-compat @tailwindcss/aspect-ratio @tailwindcss/forms @tailwindcss/typography stimulus stimulus-use @popperjs/core'
  run 'yarn add --dev prettier'
end

def add_gems
  gem 'hotwire-rails'
  gem "view_component", require: "view_component/engine"
  gem 'image_processing'
  gem 'pundit'
  gem 'devise'
  gem 'devise_invitable'
  gem 'devise_masquerade'
  gem 'omniauth-google-oauth2'
  gem 'omniauth-facebook'
  gem 'omniauth-twitter'
  gem 'omniauth-github'
  gem 'gravtastic'

  gem_group :development, :test do
    gem 'factory_bot_rails'
    gem 'faker'
  end
end

def add_multiple_authentication
    generate "model Service user:references provider uid access_token access_token_secret refresh_token expires_at:datetime auth:text"

    template = """
  if Rails.application.credentials.google_app_id.present? && Rails.application.credentials.google_app_secret.present?
    config.omniauth :google, Rails.application.credentials.google_app_id, Rails.application.credentials.google_app_secret
  end

  if Rails.application.credentials.facebook_app_id.present? && Rails.application.credentials.facebook_app_secret.present?
    config.omniauth :facebook, Rails.application.credentials.facebook_app_id, Rails.application.credentials.facebook_app_secret, scope: 'email,user_posts'
  end

  if Rails.application.credentials.twitter_app_id.present? && Rails.application.credentials.twitter_app_secret.present?
    config.omniauth :twitter, Rails.application.credentials.twitter_app_id, Rails.application.credentials.twitter_app_secret
  end

  if Rails.application.credentials.github_app_id.present? && Rails.application.credentials.github_app_secret.present?
    config.omniauth :github, Rails.application.credentials.github_app_id, Rails.application.credentials.github_app_secret
  end
    """.strip

    insert_into_file "config/initializers/devise.rb", "  " + template + "\n\n",
          before: "  # ==> Warden configuration"
end

def setup_git_repository
  FileUtils.rm_rf(Dir['.git/*']) # clear the original
  git :init
  git add: "."
end

# Main setup
add_template_repository_to_source_path
add_gems

after_bundle do
  stop_spring
  add_hotwire
  add_action_text
  add_users
  add_npm_packages
  add_multiple_authentication

  copy_templates

  setup_git_repository
end
