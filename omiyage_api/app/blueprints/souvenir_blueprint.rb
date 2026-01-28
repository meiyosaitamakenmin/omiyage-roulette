class SouvenirBlueprint < Blueprinter::Base
  identifier :id

  fields :name, :price, :category, :description, :image_url, :created_at, :updated_at

  association :user, blueprint: UserBlueprint do |souvenir|
    souvenir.user
  end
end
