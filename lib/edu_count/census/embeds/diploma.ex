defmodule EduCount.Census.Embeds.Diploma do
  use Ash.Resource, data_layer: :embedded

  attributes do
    attribute :diploma, :string, allow_nil?: false, public?: true
    attribute :subject, :string, allow_nil?: false, public?: true
  end
end
