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

divisions = %{
  "Adamaoua" => %{
    "Djérem" => ["Ngaoundal", "Tibati"],
    "Faro-et-Déo" => ["Galim-Tignère", "Kontcha", "Mayo-Baléo", "Tignère"],
    "Mayo-Banyo" => ["Bankim", "Banyo", "Mayo-Darlé"],
    "Mbéré" => ["Dir", "Djohong", "Meiganga", "Ngaoui"],
    "Vina" => [
      "Belel",
      "Martap",
      "Mbé",
      "Nganha",
      "Ngaoundéré I",
      "Ngaoundéré II",
      "Ngaoundéré III",
      "Nyambaka"
    ]
  },
  "Extrême-Nord" => %{
    "Diamaré" => [
      "Bogo",
      "Dargala",
      "Gazawa",
      "Maroua I",
      "Maroua II",
      "Maroua III",
      "Méri",
      "Ndoukoula",
      "Petté"
    ],
    "Logone-et-Chari" => [
      "Blangoua",
      "Darak",
      "Fotokol",
      "Goulfey",
      "Hile-Alifa",
      "Kousséri",
      "Logone-Birni",
      "Makary",
      "Waza",
      "Zina"
    ],
    "Mayo-Danay" => [
      "Datcheka",
      "Gobo",
      "Guéré",
      "Kaï-Kaï",
      "Kalfou",
      "Kar-Hay",
      "Maga",
      "Tchati-Bali",
      "Vele",
      "Wina",
      "Yagoua"
    ],
    "Mayo-Kani" => [
      "Guidiguis",
      "Kaélé",
      "Mindif",
      "Moulvoudaye",
      "Moutourwa",
      "Porhi",
      "Taibong"
    ],
    "Mayo-Sava" => ["Kolofata", "Mora", "Tokombéré"],
    "Mayo-Tsanaga" => [
      "Bourrha",
      "Hina",
      "Koza",
      "Mayo-Moskota",
      "Mogode",
      "Mokolo",
      "Soulédé-Roua"
    ]
  },
  "Nord" => %{
    "Bénoué" => [
      "Baschéo (Bachéo)",
      "Bibemi",
      "Dembo",
      "Demsa",
      "Garoua I",
      "Garoua II",
      "Garoua III",
      "Lagdo",
      "Mayo-Hourna",
      "Pitoa",
      "Tcheboa",
      "Touroua"
    ],
    "Faro" => ["Beka", "Poli"],
    "Mayo-Louti" => ["Figuil", "Guider", "Mayo-Oulo"],
    "Mayo-Rey" => ["Madingring", "Rey-Bouba", "Tcholliré", "Touboro"]
  },
  "Centre" => %{
    "Haute-Sanaga" => [
      "Bibey",
      "Lembe-Yezoum",
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
      "Lobo",
      "Monatélé",
      "Obala",
      "Okola",
      "Sa'a"
    ],
    "Mbam-et-Inoubou" => [
      "Bafia",
      "Bokito",
      "Deuk",
      "Kiiki",
      "Kon-Yambetta",
      "Makénéné",
      "Ndikiniméki",
      "Nitoukou",
      "Ombessa"
    ],
    "Mbam-et-Kim" => ["Mbangassina", "Ngambè-Tikar", "Ngoro", "Ntui", "Yoko"],
    "Méfou-et-Afamba" => [
      "Afanloum",
      "Assamba",
      "Awaé",
      "Edzendouan",
      "Esse",
      "Mfou",
      "Nkolafamba",
      "Soa"
    ],
    "Méfou-et-Akono" => ["Akono", "Bikok", "Mbankomo", "Ngoumou"],
    "Mfoundi" => [
      "Yaoundé I",
      "Yaoundé II",
      "Yaoundé III",
      "Yaoundé IV",
      "Yaoundé V",
      "Yaoundé VI",
      "Yaoundé VII"
    ],
    "Nyong-et-Kéllé" => [
      "Biyouha",
      "Bondjock",
      "Bot-Makak",
      "Dibang",
      "Éséka",
      "Makak",
      "Matomb",
      "Messondo",
      "Ngog-Mapubi",
      "Nguibassal"
    ],
    "Nyong-et-Mfoumou" => ["Akonolinga", "Ayos", "Endom", "Mengang", "Nyakokombo"],
    "Nyong-et-So'o" => [
      "Akoeman",
      "Dzeng",
      "Mbalmayo",
      "Mengueme",
      "Ngomedzap",
      "Nkolmetet"
    ]
  },
  "Est" => %{
    "Boumba-et-Ngoko" => ["Gari-Gombo", "Moloundou", "Salapoumbé", "Yokadouma"],
    "Haut-Nyong" => [
      "Abong-Mbang",
      "Bebend",
      "Dimako",
      "Dja",
      "Doumaintang",
      "Doumé",
      "Lomié",
      "Mboanz",
      "Mboma",
      "Messamena",
      "Messok",
      "Ngoyla",
      "Nguelemendouka",
      "Somalomo"
    ],
    "Kadey" => ["Batouri", "Bombé", "Kette", "Mbang", "Mbotoro", "Ndelele", "Ndem-Nam"],
    "Lom-et-Djérem" => [
      "Bélabo",
      "Bertoua I",
      "Bertoua II",
      "Bétaré-Oya",
      "Diang",
      "Garoua-Boulaï",
      "Mandjou",
      "Ngoura"
    ]
  },
  "Sud" => %{
    "Dja-et-Lobo" => [
      "Bengbis",
      "Djoum",
      "Meyomessala",
      "Meyomessi",
      "Mintom",
      "Oveng",
      "Sangmélima",
      "Zoétélé"
    ],
    "Mvila" => [
      "Biwong-Bane",
      "Biwong-Bulu",
      "Ebolowa I",
      "Ebolowa II",
      "Efoulan",
      "Mengong",
      "Mvangan",
      "Ngoulemakong"
    ],
    "Océan" => [
      "Akom II",
      "Bipindi",
      "Campo",
      "Kribi I",
      "Kribi II",
      "Lokoundje",
      "Lolodorf",
      "Mvengue",
      "Niété"
    ],
    "Vallée-du-Ntem" => ["Ambam", "Kyé-Ossi", "Ma'an", "Olamze"]
  },
  "Littoral" => %{
    "Moungo" => [
      "Abo Fiko (Bonaléa)",
      "Baré-Bakem",
      "Dibombari",
      "Loum",
      "Manjo",
      "Mbanga",
      "Melong",
      "Mombo",
      "Njombe-Penja",
      "Nkongsamba I",
      "Nkongsamba II",
      "Nkongsamba III",
      "Nlonako"
    ],
    "Nkam" => ["Nkondjock", "Nord-Makombé", "Yabassi", "Yingui"],
    "Sanaga-Maritime" => [
      "Dibamba",
      "Dizangué",
      "Édéa I",
      "Édéa II",
      "Massock-Songloulou",
      "Mouanko",
      "Ndom",
      "Ngambe",
      "Ngwei",
      "Nyanon",
      "Pouma"
    ],
    "Wouri" => ["Douala I", "Douala II", "Douala III", "Douala IV", "Douala V", "Douala VI"]
  },
  "Nord-Ouest" => %{
    "Boyo" => ["Belo", "Bum", "Fundong", "Njinikom"],
    "Bui" => ["Jakiri", "Kumbo", "Mbven", "Nkum", "Noni", "Oku"],
    "Donga-Mantung" => ["Ako", "Misaje", "Ndu", "Nkambé", "Nwa"],
    "Menchum" => ["Fungom", "Furu-Awa", "Menchum Valley", "Wum"],
    "Mezam" => ["Bafut", "Bali", "Bamenda I", "Bamenda II", "Bamenda III", "Santa", "Tubah"],
    "Momo" => ["Batibo", "Mbengwi", "Ngie", "Njikwa", "Widikum-Menka"],
    "Ngo-Ketunjia" => ["Babessi", "Balikumbat", "Ndop"]
  },
  "Sud-Ouest" => %{
    "Fako" => ["Buea", "Limbe I", "Limbe II", "Limbe III", "Muyuka", "Tiko", "West Coast"],
    "Koupé-Manengouba" => ["Bangem", "Nguti", "Tombel"],
    "Lebialem" => ["Alou", "Fontem", "Wabane"],
    "Manyu" => ["Akwaya", "Eyumodjock", "Mamfé Central", "Upper Banyang"],
    "Meme" => ["Konye", "Kumba I", "Kumba II", "Kumba III", "Mbonge"],
    "Ndian" => [
      "Bamusso",
      "Dikome-Balue",
      "Ekondo-Titi",
      "Idabato",
      "Isanguele",
      "Kombo-Abedimo",
      "Kombo-Itindi",
      "Mundemba",
      "Toko"
    ]
  },
  "Ouest" => %{
    "Bamboutos" => ["Babadjou", "Batcham", "Galim", "Mbouda"],
    "Haut-Nkam" => ["Bafang", "Bakou", "Bana", "Bandja", "Banka", "Banwa", "Kékem"],
    "Hauts-Plateaux" => ["Baham", "Bamendjou", "Bangou", "Batié"],
    "Koung-Khi" => ["Bandjoun", "Bayangam", "Demdeng"],
    "Menoua" => ["Dschang", "Fokoué", "Fongo-Tongo", "Nkong-Ni", "Penka-Michel", "Santchou"],
    "Mifi" => ["Bafoussam I", "Bafoussam II", "Bafoussam III"],
    "Ndé" => ["Bangangté", "Bassamba", "Bazou", "Tonga"],
    "Noun" => [
      "Bangourain",
      "Foumban",
      "Foumbot",
      "Kouoptamo",
      "Koutaba",
      "Magba",
      "Malentouen",
      "Massangam",
      "Njimom"
    ]
  }
}

regions = Map.keys(divisions) |> Enum.map(&[name: &1])

%Ash.BulkResult{records: records, status: :success} =
  Ash.bulk_create(regions, EduCount.Census.Region, :create,
    upsert?: true,
    upsert_identity: :unique_name,
    return_records?: true,
    upsert_fields: []
  )

Enum.each(records, fn region ->
  region_divisions = Map.get(divisions, region.name, %{})
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
