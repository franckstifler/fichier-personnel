defmodule EduCount.Census.Enums.ProfessionalDiplomaOption do
  use Gettext, backend: EduCountWeb.Gettext

  use Ash.Type.Enum,
    values: [
      info: gettext("INFO"),
      if: gettext("IF"),
      ii: gettext("II"),
      tic: gettext("TIC"),
      autre: gettext("Other"),
    ]
end
