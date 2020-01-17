defmodule AutoApi.SeatsState do
  @moduledoc """
  Seats state
  """

  alias AutoApi.PropertyComponent

  defstruct persons_detected: [],
            seatbelts_state: [],
            timestamp: nil

  use AutoApi.State, spec_file: "specs/seats.json"

  @type seat_location :: :front_left | :front_right | :rear_right | :rear_left | :rear_center
  @type person_detected :: :detected | :not_detected
  @type persons_detected :: %PropertyComponent{
          data: %{location: seat_location, detected: person_detected}
        }
  @type seatbelt_state :: :not_fastened | :fastened
  @type seatbelts_state :: %PropertyComponent{
          data: %{location: seat_location, fastened: seatbelt_state}
        }

  @type t :: %__MODULE__{
          persons_detected: list(persons_detected),
          seatbelts_state: list(seatbelts_state),
          timestamp: DateTime.t() | nil
        }

  @doc """
  Build state based on binary value

    iex> bin = <<2, 0, 5, 1, 0, 2, 4, 1>>
    iex> AutoApi.SeatsState.from_bin(bin)
    %AutoApi.SeatsState{persons_detected: [%AutoApi.PropertyComponent{data: %{location: :rear_center, detected: :detected}}]}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin

    iex> state = %AutoApi.SeatsState{persons_detected: [%AutoApi.PropertyComponent{data: %{location: :rear_center, detected: :detected}}]}
    iex> AutoApi.SeatsState.to_bin(state)
    <<2, 0, 5, 1, 0, 2, 4, 1>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
