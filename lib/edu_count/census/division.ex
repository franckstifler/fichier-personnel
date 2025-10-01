defmodule EduCount.Census.Division do
  use Ash.Resource,
    otp_app: :edu_count,
    domain: EduCount.Census,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "divisions"
    repo EduCount.Repo
  end

  actions do
    defaults [:read, :destroy, create: [:name, :region_id], update: [:name, :region_id]]

    read :list_alphabetically do
      prepare build(sort: [name: :asc])
    end
  end

  attributes do
    uuid_v7_primary_key :id

    attribute :name, :string do
      allow_nil? false
      public? true
    end
  end

  relationships do
    belongs_to :region, EduCount.Census.Region, allow_nil?: false
  end

  identities do
    identity :unique_name, [:name, :region_id]
  end
end
