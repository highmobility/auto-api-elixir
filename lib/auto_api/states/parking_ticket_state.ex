defmodule AutoApi.ParkingTicketState do
  @moduledoc """
  ParkingTicket state
  """

  alias AutoApi.{CommonData, PropertyComponent}

  defstruct status: nil,
            operator_name: nil,
            operator_ticket_id: nil,
            ticket_start_time: nil,
            ticket_end_time: nil,
            timestamp: nil

  use AutoApi.State, spec_file: "parking_ticket.json"

  @type parking_ticket_state :: :ended | :started

  @type t :: %__MODULE__{
          status: %PropertyComponent{data: parking_ticket_state} | nil,
          operator_name: %PropertyComponent{data: String.t()} | nil,
          operator_ticket_id: %PropertyComponent{data: String.t()} | nil,
          ticket_start_time: %PropertyComponent{data: DateTime.t()} | nil,
          ticket_end_time: %PropertyComponent{data: DateTime.t()} | nil,
          timestamp: DateTime.t() | nil
        }

  @doc """
  Build state based on binary value

    iex> bin = <<1, 0, 4, 1, 0, 1, 1>>
    iex> AutoApi.ParkingTicketState.from_bin(bin)
    %AutoApi.ParkingTicketState{status: %AutoApi.PropertyComponent{data: :started}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin

    iex> state = %AutoApi.ParkingTicketState{status: %AutoApi.PropertyComponent{data: :started}}
    iex> AutoApi.ParkingTicketState.to_bin(state)
    <<1, 0, 4, 1, 0, 1, 1>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
