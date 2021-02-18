defmodule AutoApi.SetCommand do
  @moduledoc """
  Abstraction for a `set` command in AutoApi (id `0x01`)

  The `struct` contains two fields:

  * `capability` specifies the capability of the command as a Capability module
  * `state` specifies the properties included in the command, wrapped in a State struct

  Capability and State must be of the same capability type, or an error is generated
  """

  @behaviour AutoApi.Command

  @type t :: %__MODULE__{
          capability: AutoApi.Capability.t(),
          state: AutoApi.State.t()
        }

  @enforce_keys [:capability, :state]
  defstruct [:capability, :state]

  @version AutoApi.version()
  @identifier 0x01

  @doc """
  Creates a new SetCommand structure with the given `state`.

  The `capability` module is derived from the given state structure.

  # Example

      iex> state = %AutoApi.TrunkState{lock: %AutoApi.Property{data: :locked}}
      iex> #{__MODULE__}.new(state)
      %#{__MODULE__}{capability: AutoApi.TrunkCapability, state: %AutoApi.TrunkState{lock: %AutoApi.Property{data: :locked}}}
  """

  @spec new(AutoApi.State.t()) :: t()
  def new(%state_mod{} = state) do
    new(state_mod.capability(), state)
  end

  @doc """
  Creates a new SetCommand structure with the given `capability` and `state`.

  # Example

      iex> capability = AutoApi.TrunkCapability
      iex> state = %AutoApi.TrunkState{lock: %AutoApi.Property{data: :locked}}
      iex> #{__MODULE__}.new(capability, state)
      %#{__MODULE__}{capability: AutoApi.TrunkCapability, state: %AutoApi.TrunkState{lock: %AutoApi.Property{data: :locked}}}
  """
  @spec new(AutoApi.Capability.t(), AutoApi.State.t()) :: t()
  def new(capability, state) do
    %__MODULE__{capability: capability, state: state}
  end

  @doc """
  Returns the identifier of the command.

  # Example

  iex> #{__MODULE__}.identifier()
  0x01
  """
  @impl true
  @spec identifier() :: byte()
  def identifier(), do: @identifier

  @doc """
  Transforms a SetCommand struct into binary format.

  If the command is somehow invalid, it returns an error.

  # Examples

      iex> # Request to unlock the doors of the vehicle
      iex> locks_state = %AutoApi.Property{data: :unlocked}
      iex> state = AutoApi.State.put(%AutoApi.DoorsState{}, :locks_state, locks_state)
      iex> command = %#{__MODULE__}{capability: AutoApi.DoorsCapability, state: state}
      iex> #{__MODULE__}.to_bin(command)
      <<12, 0, 32, 1, 6, 0, 4, 1, 0, 1, 0>>

      iex> # Request to honk the horn for 2.5 seconds
      iex> capability = AutoApi.HonkHornFlashLightsCapability
      iex> honk_time = %{value: 2.5, unit: :seconds}
      iex> state = AutoApi.State.put(capability.state().base(), :honk_time, data: honk_time)
      iex> command = %#{__MODULE__}{capability: capability, state: state}
      iex> #{__MODULE__}.to_bin(command)
      <<12, 0, 38, 1, 5, 0, 13, 1, 0, 10, 7, 0, 64, 4, 0, 0, 0, 0, 0, 0>>
  """
  @impl true
  @spec to_bin(t()) :: binary()
  def to_bin(%__MODULE__{capability: capability, state: %state_mod{} = state}) do
    preamble = <<@version, capability.identifier()::binary, @identifier>>

    <<preamble::binary(), state_mod.to_bin(state)::binary()>>
  end

  @doc """
  Parses a command binary and returns a SetCommand struct

  ## Examples

      iex> # Parses a "lock vehicle doors" command
      iex> #{__MODULE__}.from_bin(<<12, 0, 32, 1, 6, 0, 4, 1, 0, 1, 1>>)
      %#{__MODULE__}{capability: AutoApi.DoorsCapability, state: %AutoApi.DoorsState{locks_state: %AutoApi.Property{data: :locked}}}
  """
  @impl true
  @spec from_bin(binary) :: t()
  def from_bin(<<@version, capability_id::binary-size(2), @identifier, state_bin::binary>>) do
    capability = AutoApi.Capability.get_by_id(capability_id)
    state = capability.state().from_bin(state_bin)

    %__MODULE__{capability: capability, state: state}
  end
end
