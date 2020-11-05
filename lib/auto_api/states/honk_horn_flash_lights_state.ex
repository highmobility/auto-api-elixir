defmodule AutoApiL11.HonkHornFlashLightsState do
  @moduledoc """
  Keeps HonkHornFlashLights state
  """

  alias AutoApiL11.CommonData
  alias AutoApiL11.PropertyComponent

  @type flashers ::
          :inactive | :emergency_flasher_active | :left_flasher_active | :right_flasher_active
  @doc """
  HonkHornFlashLights state
  """
  defstruct flashers: nil,
            honk_seconds: nil,
            flash_times: nil,
            emergency_flashers_state: nil,
            timestamp: nil

  use AutoApiL11.State, spec_file: "specs/honk_horn_flash_lights.json"

  @type t :: %__MODULE__{
          flashers: %PropertyComponent{data: flashers} | nil,
          honk_seconds: %PropertyComponent{data: non_neg_integer()} | nil,
          flash_times: %PropertyComponent{data: non_neg_integer()} | nil,
          emergency_flashers_state: %PropertyComponent{data: CommonData.activity()} | nil,
          timestamp: DateTime.t() | nil
        }

  @doc """
  Build state based on binary value

    iex> bin = <<1, 0, 4, 1, 0, 1, 0>>
    iex> AutoApiL11.HonkHornFlashLightsState.from_bin(bin)
    %AutoApiL11.HonkHornFlashLightsState{flashers: %AutoApiL11.PropertyComponent{data: :inactive}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @spec to_bin(__MODULE__.t()) :: binary
  @doc """
  Parse state to bin

    iex> state = %AutoApiL11.HonkHornFlashLightsState{flashers: %AutoApiL11.PropertyComponent{data: :inactive}}
    iex> AutoApiL11.HonkHornFlashLightsState.to_bin(state)
    <<1, 0, 4, 1, 0, 1, 0>>
  """
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
