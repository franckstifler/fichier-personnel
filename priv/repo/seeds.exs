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
Ash.bulk_create(regions, EduCount.Census.Region, :create, upsert?: true, upsert_identity: :unique_name, upsert_fields: [])
|> dbg()
