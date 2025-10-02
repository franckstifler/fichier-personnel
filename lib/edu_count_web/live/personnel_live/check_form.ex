defmodule EduCountWeb.PersonnelLive.CheckForm do
  use Ash.Resource, data_layer: :embedded

  attributes do
    attribute :matricule, :string, allow_nil?: false, constraints: [min_length: 6], public?: true
    attribute :date_of_birth, :date, allow_nil?: false, public?: true
  end
end
