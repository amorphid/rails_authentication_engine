module RailsAuthenticationEngine
  # Preview all emails at http://localhost:3000/rails/mailers/foo
  class FooPreview < ActionMailer::Preview

    # Preview this email at http://localhost:3000/rails/mailers/foo/bar
    def bar
      Foo.bar
    end

  end
end
