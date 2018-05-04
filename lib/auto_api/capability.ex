# AutoAPI
# Copyright (C) 2018 High-Mobility GmbH
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see http://www.gnu.org/licenses/.
#
# Please inquire about commercial licensing options at
# licensing@high-mobility.com
defmodule AutoApi.Capability do
  @callback name() :: atom
  @callback command_name(integer) :: atom
  @callback command_name(integer) :: atom
  @callback commands :: list({integer, atom})
  @callback description :: String.t()
  @callback capability_size :: integer
  @callback capabilities :: list(any)
  @callback to_map(binary) :: list(any)
  @callback to_map(binary, integer) :: map

  defmacro __using__(_opts) do
    quote do
      @capability_size 1
      @sub_capabilities []

      @raw_spec Poison.decode!(File.read!(@spec_file))
      @identifier <<@raw_spec["id_msb"], @raw_spec["id_lsb"]>>
      @name String.to_atom(@raw_spec["name"])
      if @raw_spec["pretty_name"] do
        @desc @raw_spec["pretty_name"]
      else
        @desc @raw_spec["name"]
              |> String.split("_")
              |> Enum.map(&String.capitalize/1)
              |> Enum.join(" ")
      end

      message_types =
        @raw_spec["message_types"]
        |> Enum.map(fn msg_type -> {msg_type["id"], String.to_atom(msg_type["name"])} end)
        |> Enum.into(%{})

      @commands message_types
      properties =
        (@raw_spec["properties"] || [])
        |> Enum.map(fn prop -> {prop["id"], String.to_atom(prop["name"])} end)

      @properties properties

      @command_ids Enum.into(Enum.map(@commands, fn {k, v} -> {v, k} end), %{})

      @commands_list Enum.into(@commands, [])

      @doc false
      @spec raw_spec() :: map()
      def raw_spec, do: @raw_spec

      @doc """
      Returns map of commands id and thier name

        #{inspect @commands_list, base: :hex}
      """
      @spec commands :: list({integer, atom})
      def commands, do: @commands_list

      @doc """
      Returns the command module related to this capability
      """
      @spec command :: atom
      def command, do: @command_module

      @doc """
      Returns the command module related to this capability
      """
      # @spec state() :: atom
      def state, do: @state_module

      @doc """
      Retunrs capability's identifier: #{inspect @identifier, base: :hex}
      """
      @spec identifier :: binary
      def identifier, do: @identifier

      @doc """
      Returns capability's unique name: #{@name}
      """
      @spec name :: atom
      def name, do: @name

      @doc """
      Returns capability's description: #{@desc}
      """
      @spec description :: String.t()
      def description, do: @desc

      @doc """
      Returns commands readable name.

      Available commands:

      ```
      #{inspect @commands, base: :hex}
      ```
      """
      @spec command_name(integer) :: __MODULE__.command_type() | nil
      def command_name(id), do: Map.get(@commands, id)

      @doc """
      Return commands id based on atom
      """
      @spec command_id(__MODULE__.command_type()) :: integer | nil
      def command_id(name), do: Map.get(@command_ids, name, -1)

      @doc """
      Deprecated. Use API level 5 and above.

      Returns capability size: #{@capability_size}
      """
      @deprecated "Use API level 5 and above"
      @spec capability_size :: integer
      def capability_size, do: @capability_size

      @doc """
      Deprecated. Use API level 5 and above.

      Retunrs capabilities under #{@desc}:

      ```
      #{inspect @sub_capabilities}
      ```
      """
      @deprecated "Use API level 5 and above"
      @spec capabilities :: list(map())
      def capabilities, do: @sub_capabilities

      @doc """
      Retunrs properties under #{@desc}:
      ```
      #{inspect @properties, base: :hex}
      ```
      """
      @spec properties :: list(tuple())
      def properties, do: @properties

      @doc """
      Returns list of supported sub capability based on binary value

      Level 5:

          ie> HmAutoApi.DoorLocksCapability.to_map(<<0x00, 0x20, 0x01, 0x00, 0x02>>)
          [:lock_state, :get_lock_state, :lock_unlock_doors]


      Level 4:
          ie> HmAutoApi.DoorLocksCapability.to_map(<<0x1, 0x0>>)
          [%{bin: <<0x00>>, name: "Unavailable", atom: :unavailable, title: ""}]


      """
      @spec to_map(binary) :: list(command_type) :: list(map)
      def to_map(capability_bin) do
        id = @identifier

        case capability_bin do
          <<^id::binary-size(2), caps::binary>> ->
            caps
            |> :binary.bin_to_list()
            |> Enum.map(fn action -> command_name(action) end)

          _ ->
            to_map_l4(capability_bin)
        end
      end

      @doc """
      Deprecated. Use API level 5 and above.
      """
      @deprecated "Use API level 5 and above"
      def to_map_l4(<<size, sub_caps::binary-size(size), rest::binary>>) do
        len = capability_size()
        sub_caps_list = :binary.bin_to_list(sub_caps)

        for index <- 0..(len - 1) do
          cap_bin = Enum.at(sub_caps_list, index)
          to_map(<<cap_bin>>, index)
        end
      end

      @doc """
      Deprecated. Use API level 5 and above.
      """
      @deprecated "Use API level 5 and above"
      def to_map(sub_cap_bin, index) when is_binary(sub_cap_bin) do
        sub_cap = Enum.at(@sub_capabilities, index)
        title = Map.get(sub_cap, :title, "")

        {cap_atom, cap_detail} =
          sub_cap.options
          |> Enum.filter(fn {_, opt} -> opt[:bin] == sub_cap_bin end)
          |> List.first()

        cap_detail
        |> Map.put(:atom, cap_atom)
        |> Map.put(:title, title)
      end

      @doc """
      Returns binary value of capability based on list of available supported capabilities
      """
      @spec to_bin(list(command_type)) :: binary
      def to_bin(actions_list) do
        cap_iden = identifier()

        caps_binary =
          actions_list
          |> Enum.map(fn cap -> command_id(cap) end)
          |> :binary.list_to_bin()

        cap_iden <> caps_binary
      end
    end
  end

  @capabilities %{
    <<0x00, 0x03>> => AutoApi.FirmwareVersionCapability,
    <<0x00, 0x10>> => AutoApi.CapabilitiesCapability,
    <<0x00, 0x33>> => AutoApi.DiagnosticsCapability,
    <<0x00, 0x20>> => AutoApi.DoorLocksCapability,
    <<0x00, 0x42>> => AutoApi.WindscreenCapability,
    <<0x00, 0x45>> => AutoApi.WindowsCapability,
    <<0x00, 0x59>> => AutoApi.WiFiCapability,
    <<0x00, 0x55>> => AutoApi.WeatherConditionsCapability,
    <<0x00, 0x22>> => AutoApi.WakeUpCapability,
    <<0x00, 0x43>> => AutoApi.VideoHandoverCapability,
    <<0x00, 0x50>> => AutoApi.VehicleTimeCapability,
    <<0x00, 0x11>> => AutoApi.VehicleStatusCapability,
    <<0x00, 0x30>> => AutoApi.VehicleLocationCapability,
    <<0x00, 0x21>> => AutoApi.TrunkCapability,
    <<0x00, 0x46>> => AutoApi.TheftAlarmCapability,
    <<0x00, 0x44>> => AutoApi.TextInputCapability,
    <<0x00, 0x25>> => AutoApi.RooftopControlCapability,
    <<0x00, 0x27>> => AutoApi.RemoteControlCapability,
    <<0x00, 0x28>> => AutoApi.ValetModeCapability,
    <<0x00, 0x57>> => AutoApi.RaceCapability,
    <<0x00, 0x47>> => AutoApi.ParkingTicketCapability,
    <<0x00, 0x58>> => AutoApi.ParkingBrakeCapability,
    <<0x00, 0x56>> => AutoApi.SeatsCapability,
    <<0x00, 0x34>> => AutoApi.MaintenanceCapability,
    <<0x00, 0x49>> => AutoApi.BrowserCapability,
    <<0x00, 0x23>> => AutoApi.ChargingCapability,
    <<0x00, 0x53>> => AutoApi.ChassisSettingsCapability,
    <<0x00, 0x24>> => AutoApi.ClimateCapability,
    <<0x00, 0x41>> => AutoApi.DriverFatigueCapability,
    <<0x00, 0x35>> => AutoApi.EngineCapability,
    <<0x00, 0x40>> => AutoApi.FuelingCapability,
    <<0x00, 0x51>> => AutoApi.GraphicsCapability,
    <<0x00, 0x29>> => AutoApi.HeartRateCapability,
    <<0x00, 0x60>> => AutoApi.HomeChargerCapability,
    <<0x00, 0x48>> => AutoApi.KeyfobPositionCapability,
    <<0x00, 0x36>> => AutoApi.LightsCapability,
    <<0x00, 0x54>> => AutoApi.LightConditionsCapability,
    <<0x00, 0x37>> => AutoApi.MessagingCapability,
    <<0x00, 0x31>> => AutoApi.NaviDestinationCapability,
    <<0x00, 0x38>> => AutoApi.NotificationsCapability,
    <<0x00, 0x52>> => AutoApi.OffroadCapability,
    <<0x00, 0x26>> => AutoApi.HonkHornFlashLightsCapability,
    <<0x00, 0x61>> => AutoApi.DashboardLightsCapability,
    <<0x00, 0x63>> => AutoApi.StartStopCapability
  }

  @doc """
    Returns full capabilities with all of them marked as disabled

      ie> <<cap_len, first_cap :: binary-size(3), _::binary>> = AutoApi.Capability.blank_capabilities
      ie> cap_len
      8
      ie> first_cap
      <<0, 0x20, 0>>
  """
  def blank_capabilities do
    caps_len = length(Map.keys(@capabilities))

    for {_, cap_module} <- @capabilities do
      iden = apply(cap_module, :identifier, [])

      cap_module
      |> apply(:capabilities, [])
      |> Enum.map(fn _ -> <<0>> end)
      |> Enum.reduce(iden, fn i, x -> x <> i end)
    end
    |> Enum.reduce(<<caps_len>>, fn i, x -> x <> i end)
  end

  def list_capabilities, do: @capabilities
end
