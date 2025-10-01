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

    resource EduCount.Census.SubDivision
  end
end
