require "administrate/base_dashboard"

class FranchiseDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    user: Field::BelongsTo,
    id: Field::Number,
    name: Field::String,
    owner: Field::String,
    email: Field::String,
    phone_number: Field::Number,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    role: Field::String.with_options(searchable: false),
    address: Field::String,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :user,
    :id,
    :name,
    :owner,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :user,
    :id,
    :name,
    :owner,
    :email,
    :phone_number,
    :created_at,
    :updated_at,
    :role,
    :address,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :user,
    :name,
    :owner,
    :email,
    :phone_number,
    :role,
    :address,
  ].freeze

  # Overwrite this method to customize how franchises are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(franchise)
  #   "Franchise ##{franchise.id}"
  # end
end
