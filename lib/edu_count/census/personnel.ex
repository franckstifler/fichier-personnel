defmodule EduCount.Census.Personnel do
  use Ash.Resource,
    otp_app: :edu_count,
    domain: EduCount.Census,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "personnels"
    repo EduCount.Repo
  end

  actions do
    default_accept [
      :last_name,
      :first_name,
      :matricule,
      :maiden_name,
      :gender,
      :language,
      :date_of_birth,
      :place_of_birth,
      :matrimonial_status,
      :children_count,
      :grade,
      :professional_diploma,
      :professional_diploma_option,
      :degree_subject,
      :other_diplomas,
      :fonction,
      :first_effective_service_date,
      :current_post_effective_service_date,
      :telephone,
      :email,
      :sub_division_appointed_id,
      :sub_division_of_origin_id
    ]

    defaults [:read, :destroy, :create, :update]
  end

  validations do
    validate present([:last_name, :first_name], at_least: 1)

    validate present(:maiden_name),
      where: [
        attribute_equals(:gender, :female),
        attribute_in(:matrimonial_status, [:married, :divorced, :widowed])
      ]

    validate compare(:first_effective_service_date,
               less_than_or_equal_to: :current_post_effective_service_date
             )
  end

  attributes do
    uuid_v7_primary_key :id
    attribute :last_name, :string, allow_nil?: false, public?: true, constraints: [trim?: true]
    attribute :first_name, :string, allow_nil?: false, public?: true, constraints: [trim?: true]
    attribute :maiden_name, :string, public?: true
    attribute :gender, EduCount.Census.Enums.Gender, allow_nil?: false, public?: true
    attribute :date_of_birth, :date, allow_nil?: false, public?: true
    attribute :place_of_birth, :string, allow_nil?: false, public?: true

    attribute :matrimonial_status, EduCount.Census.Enums.MatrimonialStatus,
      allow_nil?: false,
      public?: true

    attribute :children_count, :integer, allow_nil?: false, default: 0, public?: true
    attribute :matricule, :string, allow_nil?: false, public?: true, constraints: [trim?: true]
    attribute :grade, EduCount.Census.Enums.Grade, allow_nil?: false, public?: true

    attribute :professional_diploma, :string, public?: true, constraints: [trim?: true]

    attribute :professional_diploma_option, EduCount.Census.Enums.ProfessionalDiplomaOption,
      public?: true

    attribute :language, EduCount.Census.Enums.Language, allow_nil?: false, public?: true

    attribute :degree_subject, :string, public?: true, constraints: [trim?: true]
    attribute :other_diplomas, {:array, EduCount.Census.Embeds.Diploma}, public?: true
    attribute :fonction, EduCount.Census.Enums.Fonction, allow_nil?: false, public?: true
    attribute :first_effective_service_date, :date, allow_nil?: false, public?: true
    attribute :current_post_effective_service_date, :date, allow_nil?: false, public?: true
    attribute :telephone, :string, public?: true, constraints: [trim?: true]
    attribute :email, :string, public?: true, constraints: [trim?: true]
  end

  relationships do
    belongs_to :sub_division_appointed, EduCount.Census.SubDivision do
      source_attribute :sub_division_appointed_id
    end

    belongs_to :sub_division_of_origin, EduCount.Census.SubDivision do
      source_attribute :sub_division_of_origin_id
    end
  end

  calculations do
    calculate :full_name, :string, expr(last_name <> " " <> first_name)

    calculate :full_region_of_origin,
              :string,
              expr(
                sub_division_of_origin.division.region.name <>
                  " | " <>
                  sub_division_of_origin.division.name <> " | " <> sub_division_of_origin.name
              )

    calculate :full_region_appointed,
              :string,
              expr(
                sub_division_appointed.division.region.name <>
                  " | " <>
                  sub_division_appointed.division.name <> " | " <> sub_division_appointed.name
              )
  end

  identities do
    identity :unique_matricule, [:matricule]
    identity :unique_name_dob, [:last_name, :first_name, :date_of_birth]
  end
end
