class UserBlueprint < Blueprinter::Base
  identifier :id

  fields :name, :email, :avatar_url, :created_at, :updated_at
end
