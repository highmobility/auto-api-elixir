defmodule AutoApiL11.FirmwareVersionState do
  @moduledoc """
  Keeps Firmware Version state

  """

  alias AutoApiL11.PropertyComponent

  @type hmkit_version :: %PropertyComponent{
          data: %{
            major: integer,
            minor: integer,
            patch: integer
          }
        }

  @doc """
  Firmware Version state
  """
  defstruct hmkit_version: nil,
            hmkit_build_name: nil,
            application_version: nil,
            timestamp: nil

  use AutoApiL11.State, spec_file: "specs/firmware_version.json"

  @type t :: %__MODULE__{
          hmkit_version: hmkit_version | nil,
          hmkit_build_name: %PropertyComponent{data: String.t()} | nil,
          application_version: %PropertyComponent{data: String.t()} | nil,
          timestamp: DateTime.t() | nil
        }

  @doc """
  Build state based on binary value

    iex> bin = <<3, 0, 8, 1, 0, 5, 51, 46, 49, 46, 55>>
    iex> AutoApiL11.FirmwareVersionState.from_bin(bin)
    %AutoApiL11.FirmwareVersionState{application_version: %AutoApiL11.PropertyComponent{data: "3.1.7"}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @spec to_bin(__MODULE__.t()) :: binary
  @doc """
  Parse state to bin

    iex> state = %AutoApiL11.FirmwareVersionState{application_version: %AutoApiL11.PropertyComponent{data: "3.1.7"}}
    iex> AutoApiL11.FirmwareVersionState.to_bin(state)
    <<3, 0, 8, 1, 0, 5, 51, 46, 49, 46, 55>>
  """
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
