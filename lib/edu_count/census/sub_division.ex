defmodule EduCount.Census.SubDivision do
  use Ash.Resource,
    otp_app: :edu_count,
    domain: EduCount.Census,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "sub_divisions"
    repo EduCount.Repo
  end

  actions do
    defaults [:read, :destroy]

    read :list_alphabetically do
      prepare build(sort: [name: :asc])
    end

    read :search_by_name do
      argument :search, :ci_string, public?: true
      pagination keyset?: true, default_limit: 10

      filter expr(contains(name, ^arg(:search)))
    end

    create :create do
      primary? true
      accept [:name, :division_id]
      argument :region_id, :uuid_v7, public?: true
    end

    update :update do
      primary? true
      accept [:name, :division_id]
      argument :region_id, :uuid_v7, public?: true
    end
  end

  attributes do
    uuid_primary_key :id

    attribute :name, :string do
      allow_nil? false
      public? true
    end
  end

  relationships do
    belongs_to :division, EduCount.Census.Division
  end

  identities do
    identity :unique_name, [:name, :division_id]
  end
end
