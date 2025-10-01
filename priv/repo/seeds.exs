# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     EduCount.Repo.insert!(%EduCount.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
regions = [
  [name: "Extreme Nord"],
  [name: "Nord"],
  [name: "Sud"],
  [name: "Est"],
  [name: "Ouest"],
  [name: "Centre"],
  [name: "Adamaoua"],
  [name: "Littoral"],
  [name: "Nord-Ouest"],
  [name: "Sud-Ouest"]
]

Ash.bulk_create(regions, EduCount.Census.Region, :create,
  upsert?: true,
  upsert_identity: :unique_name,
  upsert_fields: []
)

divisions = %{
  "Centre" => [
    "Haute-Sanaga",
    "Lekié",
    "Mbam-et-Inoubou",
    "Mbam-et-Kim",
    "Méfou-et-Afamba",
    "Méfou-et-Akono",
    "Mfoundi",
    "Nyong-et-Kéllé",
    "Nyong-et-Mfoumou",
    "Nyong-et-So'o"
  ]
}

Enum.each(regions, fn [name: name] ->
  region_divisions = Map.get(divisions, name, [])
  region = EduCount.Census.get_region_by_name!(name)

  Enum.map(region_divisions, fn division_name ->
    %{name: division_name, region_id: region.id}
  end)
  |> Ash.bulk_create(EduCount.Census.Division, :create,
    upsert?: true,
    upsert_identity: :unique_name,
    upsert_fields: [],
    authorize?: false
  )
end)
