defmodule EduCountWeb.PersonnelLive.Form do
  use EduCountWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.form flash={@flash}>
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage personnel records in your database.</:subtitle>
      </.header>

      <.form for={@form} id="personnel-form" phx-change="validate" phx-submit="save">
        <div>
          <fieldset class="fieldset col-span-2 bg-base-200 border-base-300 p-4 rounded">
            <legend class="fieldset-legend">
              {gettext("Basic infos")}
            </legend>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-x-4">
              <.input field={@form[:last_name]} type="text" label={gettext("Last name")} />
              <.input field={@form[:first_name]} type="text" label={gettext("First name")} />
              <.input
                field={@form[:gender]}
                type="select"
                prompt={gettext("Select a gender")}
                label={gettext("Gender")}
                options={
                  EduCount.Census.Enums.Gender.values()
                  |> Enum.map(fn value ->
                    label = EduCount.Census.Enums.Gender.description(value)
                    {label, value}
                  end)
                }
              />
              <.input
                field={@form[:matrimonial_status]}
                type="select"
                prompt={gettext("Select a matrimonial status")}
                label={gettext("Matrimonial status")}
                options={
                  EduCount.Census.Enums.MatrimonialStatus.values()
                  |> Enum.map(fn value ->
                    label = EduCount.Census.Enums.MatrimonialStatus.description(value)
                    {label, value}
                  end)
                }
              />
            </div>
            <div class="col=span-2">
              <.input
                :if={
                  @form[:gender].value == :female and
                    @form[:matrimonial_status].value in [:married, :widowed]
                }
                field={@form[:maiden_name]}
                type="text"
                label={gettext("Maiden name")}
              />
            </div>
            <.input
              field={@form[:matricule]}
              type="text"
              label={gettext("Matricule")}
              info_label={gettext("Enter your matricule using the new format.")}
            />
            <.input field={@form[:date_of_birth]} type="date" label={gettext("Date of birth")} />
            <.input field={@form[:place_of_birth]} type="text" label={gettext("Place of birth")} />
            <.live_select
              update_min_len={2}
              field={@form[:sub_division_of_origin_id]}
              label={gettext("Sub division of origin")}
            />
            <.input field={@form[:children_count]} type="number" label={gettext("Children count")} />
          </fieldset>
          <fieldset class="fieldset col-span-2 bg-base-200 border-base-300 p-4 rounded">
            <legend class="fieldset-legend">
              {gettext("Professional details")}
            </legend>
            <.input
              field={@form[:grade]}
              type="select"
              label={gettext("Grade")}
              options={
                EduCount.Census.Enums.Grade.values()
                |> Enum.map(fn value ->
                  label = EduCount.Census.Enums.Grade.description(value)
                  {label, value}
                end)
              }
            />
            <.input
              field={@form[:professional_diploma]}
              type="text"
              info_label={gettext("DIPET I, DIPES II, CAPES, etc...")}
              label={gettext("Professional diploma")}
            />
            <.input
              field={@form[:professional_diploma_option]}
              type="select"
              prompt={gettext("Select a professional diploma option")}
              label={gettext("Professional diploma option")}
              info_label={gettext("Speciality of your professional certificate: INFO, II...")}
              options={
                EduCount.Census.Enums.ProfessionalDiplomaOption.values()
                |> Enum.map(fn value ->
                  label = EduCount.Census.Enums.ProfessionalDiplomaOption.description(value)
                  {label, value}
                end)
              }
            />
            <.input
              field={@form[:fonction]}
              type="select"
              prompt={gettext("Select a fonction")}
              label={gettext("Fonction")}
              options={
                EduCount.Census.Enums.Fonction.values()
                |> Enum.map(fn value ->
                  label = EduCount.Census.Enums.Fonction.description(value)
                  {label, value}
                end)
              }
            />
            <.input
              field={@form[:language]}
              type="select"
              prompt={gettext("Select a language")}
              label={gettext("Language")}
              options={
                EduCount.Census.Enums.Language.values()
                |> Enum.map(fn value ->
                  label = EduCount.Census.Enums.Language.description(value)
                  {label, value}
                end)
              }
            />
          </fieldset>
          <fieldset class="fieldset col-span-2 bg-base-200 border-base-300 p-4 rounded">
            <legend class="fieldset-legend">
              {gettext("University diplomas")}
            </legend>
            <.input
              field={@form[:degree_subject]}
              type="text"
              label={gettext("Degree subject")}
              info_label={gettext("The subject in which you obtained your degree e.g: Biology")}
            />
            <label class="label">
              <input
                type="checkbox"
                name={"#{@form.name}[_add_other_diplomas]"}
                value="end"
                class="hidden"
              />
              <.icon name="hero-plus" />
              {gettext("Other diplomas")}
            </label>
            <label></label>
            <.inputs_for :let={other_diploma_form} field={@form[:other_diplomas]}>
              <div class="flex items-center">
                <div class="grow grid grid-cols-2 gap-x-4">
                  <.input field={other_diploma_form[:diploma]} type="text" label={gettext("Diploma")} />
                  <.input field={other_diploma_form[:subject]} type="text" label={gettext("Subject")} />
                </div>
                <label class="w-10 ml-2 mt-3">
                  <input
                    type="checkbox"
                    name={"#{@form.name}[_drop_other_diplomas][]"}
                    value={other_diploma_form.index}
                    class="hidden"
                  />

                  <.icon name="hero-x-mark cursor-pointer text-red-800" />
                </label>
              </div>
            </.inputs_for>
          </fieldset>
          <div class="col-span-2"></div>
          <fieldset class="fieldset col-span-2 bg-base-200 border-base-300 p-4 rounded">
            <legend class="fieldset-legend">
              {gettext("Dates of service")}
            </legend>

            <.input
              field={@form[:first_effective_service_date]}
              type="date"
              label={gettext("First effective service date")}
            />
            <.input
              field={@form[:current_post_effective_service_date]}
              type="date"
              label={gettext("Current post effective service date")}
            />
            <.live_select
              update_min_len={2}
              field={@form[:sub_division_appointed_id]}
              label={gettext("Sub division appointed")}
            />
          </fieldset>
          <fieldset class="fieldset col-span-2 bg-base-200 border-base-300 p-4 rounded">
            <legend class="fieldset-legend">
              {gettext("Contact")}
            </legend>
            <.input field={@form[:telephone]} type="text" label={gettext("Telephone")} />
            <.input field={@form[:email]} type="text" label={gettext("Email")} />
          </fieldset>
        </div>

        <.button phx-disable-with="Saving..." variant="primary">{gettext("Save")}</.button>
        <.button navigate={return_path(@return_to, @personnel)}>{gettext("Cancel")}</.button>
      </.form>
    </Layouts.form>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    personnel =
      case params["id"] do
        nil -> nil
        id -> Ash.get!(EduCount.Census.Personnel, id)
      end

    action = if is_nil(personnel), do: gettext("New"), else: gettext("Edit")
    page_title = action <> " " <> gettext("Personnel")

    {:ok,
     socket
     |> assign(:return_to, return_to(params["return_to"]))
     |> assign(personnel: personnel)
     |> assign(:page_title, page_title)
     |> assign_form()}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  @impl true
  def handle_event("live_select_change", %{"text" => text, "id" => live_select_id}, socket) do
    %{results: subdivisions} = EduCount.Census.search_sub_divition_by_name!(text)

    options = Enum.map(subdivisions, &{&1.name, &1.id})

    send_update(LiveSelect.Component, id: live_select_id, options: options)

    {:noreply, socket}
  end

  def handle_event("validate", %{"personnel" => personnel_params}, socket) do
    {:noreply,
     assign(socket, form: AshPhoenix.Form.validate(socket.assigns.form, personnel_params))}
  end

  def handle_event("save", %{"personnel" => personnel_params}, socket) do
    case AshPhoenix.Form.submit(socket.assigns.form, params: personnel_params) do
      {:ok, personnel} ->
        notify_parent({:saved, personnel})

        socket =
          socket
          |> put_flash(:info, "Personnel #{socket.assigns.form.source.type}d successfully")
          |> push_navigate(to: return_path(socket.assigns.return_to, personnel))

        {:noreply, socket}

      {:error, form} ->
        dbg(form)
        {:noreply, assign(socket, form: form)}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})

  defp assign_form(%{assigns: %{personnel: personnel}} = socket) do
    form =
      if personnel do
        AshPhoenix.Form.for_update(personnel, :update, as: "personnel")
      else
        AshPhoenix.Form.for_create(EduCount.Census.Personnel, :create, as: "personnel")
      end

    assign(socket, form: to_form(form))
  end

  defp return_path("index", _personnel), do: ~p"/personnels"
  defp return_path("show", personnel), do: ~p"/personnels/#{personnel.id}"
end
