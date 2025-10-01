defmodule EduCount.Census do
  use Ash.Domain,
    otp_app: :edu_count

  resources do
    resource EduCount.Census.Region
  end
end
