defmodule EduCountWeb.DownloadController do
  use EduCountWeb, :controller
  require Ash.Query

  def personnel_download(conn, _params) do
    # sheet =
    #   "Personnels"
    #   |> Sheet.with_name()
    #   |> Sheet.set_cell("A2", gettext("REGION: "))
    #   |> Sheet.set_cell("D2", gettext("DIVISION: "))
    #   |> Sheet.set_cell("I2", gettext("SUB-DIVISION: "))
    #   |> Sheet.set_cell("N2", gettext("SCHOOL: "))
    #   |> Sheet.set_cell("A5", gettext("S/N"))
    #   |> Sheet.set_cell("B5", gettext("NAME"))
    #   |> Sheet.set_cell("B5", gettext("LAST NAME"))
    #   |> Sheet.set_cell("C5", gettext("Maiden Name"))
    #   |> Sheet.set_cell("D5", gettext("Gender"))
    #   |> Sheet.set_cell("E5", gettext("Date of Birth"))
    #   |> Sheet.set_cell("F5", gettext("Place of Birth"))
    #   |> Sheet.set_cell("G5", gettext("Matrimonial Status"))
    #   |> Sheet.set_cell("H5", gettext("Number of Children"))
    #   |> Sheet.set_cell("I5", gettext("Sub-Division of Origin"))
    #   |> Sheet.set_cell("J5", gettext("Matricule"))
    #   |> Sheet.set_cell("K5", gettext("Grade"))
    #   |> Sheet.set_cell("L5", gettext("Cerfificate"))
    #   |> Sheet.set_cell("M5", gettext("Option"))
    #   |> Sheet.set_cell("N5", gettext("Bachelor's degree"))
    #   |> Sheet.set_cell("O5", gettext("Post Graduate"))
    #   |> Sheet.set_cell("P5", gettext("Fonction"))
    #   |> Sheet.set_cell("Q5", gettext("Language"))
    #   |> Sheet.set_cell("R5", gettext("First Service Date"))
    #   |> Sheet.set_cell("S5", gettext("Actual Service Date"))
    #   |> Sheet.set_cell("T5", gettext("Phone Number"))
    #   |> Sheet.set_cell("U5", gettext("Email Address"))

    headers = [
      gettext("S/N"),
      gettext("Name"),
      gettext("Last Name"),
      gettext("Maiden Name"),
      gettext("Gender"),
      gettext("Date of Birth"),
      gettext("Place of Birth"),
      gettext("Matrimonial Status"),
      gettext("Number of Children"),
      gettext("Sub-Division of Origin"),
      gettext("Matricule"),
      gettext("Grade"),
      gettext("Cerfificate"),
      gettext("Option"),
      gettext("Bachelor's degree"),
      gettext("Post Graduate"),
      gettext("Fonction"),
      gettext("Language"),
      gettext("First Service Date"),
      gettext("Actual Service Date"),
      gettext("Phone Number"),
      gettext("Email Address"),
      gettext("Region"),
      gettext("Division"),
      gettext("Sub-division"),
      gettext("School")
    ]

    now = DateTime.utc_now() |> DateTime.to_unix()
    file_name = "personnels_#{now}.csv"
    temp_dir = System.tmp_dir!()
    file_path = Path.join(temp_dir, file_name)
    file = File.open!(file_path, [:write, :utf8])

    [headers]
    |> CSV.encode()
    |> Enum.each(&IO.write(file, &1))

    EduCount.Census.Personnel
    |> Ash.Query.for_read(:read, %{},
      load: [:sub_division_of_origin, sub_division_appointed: [division: :region]]
    )
    |> Ash.stream!()
    |> Stream.with_index(1)
    |> Stream.map(fn {personnel, index} ->
      other_diplomas =
        (personnel.other_diplomas || [])
        |> Enum.map(fn diploma ->
          "#{diploma.diploma}: (#{diploma.subject})"
        end)
        |> Enum.join(", ")

      [
        index,
        personnel.first_name,
        personnel.last_name,
        personnel.maiden_name,
        EduCount.Census.Enums.Gender.description(personnel.gender),
        personnel.date_of_birth,
        personnel.place_of_birth,
        EduCount.Census.Enums.MatrimonialStatus.description(personnel.matrimonial_status),
        personnel.children_count,
        personnel.sub_division_of_origin.name,
        personnel.matricule,
        EduCount.Census.Enums.Grade.description(personnel.grade),
        personnel.professional_diploma,
        EduCount.Census.Enums.ProfessionalDiplomaOption.description(
          personnel.professional_diploma_option
        ),
        personnel.degree_subject,
        other_diplomas,
        EduCount.Census.Enums.Fonction.description(personnel.fonction),
        EduCount.Census.Enums.Language.description(personnel.language),
        personnel.first_effective_service_date,
        personnel.current_post_effective_service_date,
        personnel.telephone,
        personnel.email,
        personnel.sub_division_appointed.division.region.name,
        personnel.sub_division_appointed.division.name,
        personnel.sub_division_appointed.name
        # personnel.school_name
      ]
    end)
    |> CSV.encode()
    |> Stream.each(&IO.write(file, &1))
    |> Stream.run()

    send_download(conn, {:file, file_path}, filename: file_name)
  end
end
