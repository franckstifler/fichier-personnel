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
  "Centre" => %{
    "Haute-Sanaga" => [
      "Bibey",
      "Lembe Yezoum",
      "Mbandjock",
      "Minta",
      "Nanga-Eboko",
      "Nkoteng",
      "Nsem"
    ],
    "Lekié" => [
      "Batchenga",
      "Ebebda",
      "Elig-Mfomo",
      "Evodoula",
      "Monatelé",
      "Obala",
      "Okola",
      "Sa'a"
    ],
    "Méfou et Afamba" => [
      "Afanloum",
      "Awaé",
      "Edzendouan",
      "Esse",
      "Nkolafamba",
      "Olanguina",
      "Soa"
    ],
    "Mbam Inoubou" => [
      "Bafia",
      "Bokito",
      "Deuk",
      "Kiiki",
      "Kun-Yambetta",
      "Makénéné",
      "Ndikinemeki",
      "Nitoukou",
      "Ombessa"
    ],
    "Mbam et Kim" => [
      "Mbangassina",
      "Ngambè-Tikar",
      "Ngoro",
      "Ntui",
      "Yoko"
    ],
    "Mfoundi" => [
      # Nlongkak
      "Yaoundé 1",
      # Tsinga
      "Yaoundé 2",
      # Efoulan
      "Yaoundé 3",
      # Kondengui
      "Yaoundé 4",
      # Nkolmesseng
      "Yaoundé 5",
      # Biyem-Assi
      "Yaoundé 6",
      # Nkolbisson
      "Yaoundé 7"
    ],
    "Méfou et Akono" => [
      "Akono",
      "Bikok",
      "Mbankomo",
      "Ngoumou"
    ],
    "Nyong et Kelle" => [
      "Biyouha",
      "Bondjock",
      "Bot-Makak",
      "Dibang",
      "Eséka",
      "Makak",
      "Matomb",
      "Messondo",
      "Ngog Mapubi",
      "Nguibassal"
    ],
    "Nyong et Mfoumou" => [
      "Akonolinga",
      "Ayos",
      "Endom",
      "Mengang",
      "Nyakokombo  (Kobdombo)"
    ],
    "Nyong et So'o" => [
      "Akoeman",
      "Dzeng",
      "Mbalmayo",
      "Mengueme",
      "Ngomedzap",
      "Nkolmetet"
    ]
  }
}

Enum.each(regions, fn [name: name] ->
  region_divisions = Map.get(divisions, name, %{})
  region = EduCount.Census.get_region_by_name!(name)
  divions_names = Map.keys(region_divisions)

  %Ash.BulkResult{records: records, status: :success} =
    Enum.map(divions_names, fn division_name ->
      %{name: division_name, region_id: region.id}
    end)
    |> Ash.bulk_create(EduCount.Census.Division, :create,
      upsert?: true,
      upsert_identity: :unique_name,
      upsert_fields: [],
      return_records?: true,
      authorize?: false
    )

  records
  |> Enum.each(fn division ->
    sub_division_names = Map.get(region_divisions, division.name, [])

    Ash.bulk_create(
      Enum.map(sub_division_names, fn sub_division_name ->
        %{name: sub_division_name, division_id: division.id}
      end),
      EduCount.Census.SubDivision,
      :create,
      upsert?: true,
      upsert_identity: :unique_name,
      upsert_fields: [],
      authorize?: false
    )
  end)
end)
