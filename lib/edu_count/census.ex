defmodule EduCount.Census do
  use Ash.Domain,
    otp_app: :edu_count

  resources do
    resource EduCount.Census.Region do
      define :get_region_by_name, action: :read, get_by: :name
      define :list_regions_alphabetically, action: :list_alphabetically
    end

    resource EduCount.Census.Division do
      define :list_divisions_alphabetically, action: :list_alphabetically
      define :list_region_divisions, action: :list_region_divisions, args: [:region_id]
    end

    resource EduCount.Census.SubDivision do
      define :search_sub_divition_by_name, action: :search_by_name, args: [:search]
      define :list_sub_divisions_alphabetically, action: :list_alphabetically
    end

    resource EduCount.Census.Personnel do
      define :get_personnel_by_matricule_and_date_of_birth,
        action: :read,
        get_by: [:matricule, :date_of_birth]
    end
  end
end
