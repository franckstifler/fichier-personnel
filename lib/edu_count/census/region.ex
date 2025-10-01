defmodule EduCount.Census.Region do
  use Ash.Resource,
    otp_app: :edu_count,
    domain: EduCount.Census,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "regions"
    repo EduCount.Repo
  end

  actions do
    defaults [:read, :destroy, create: [:name], update: [:name]]
  end

  attributes do
    uuid_v7_primary_key :id

    attribute :name, :string do
      allow_nil? false
      public? true
    end
  end

  identities do
    identity :unique_name, [:name]
  end
end
