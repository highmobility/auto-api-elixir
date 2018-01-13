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
defmodule AutoApi.CapabilityParser do
  @moduledoc """
  Parse Capability from binary to map and vise versa

  Read more https://developers.high-mobility.com/resources/documentation/auto-api/api-structure/capabilities
  """

  alias AutoApi.Capability

  @doc """
  Converts capabilities in binary to map

      iex> bin_caps = <<0x01>> <> <<0x01, 0x00, 0x05, 0x00, 0x20, 0x01, 0x00, 0x02>>
      iex> AutoApi.CapabilityParser.to_map(bin_caps)
      {:ok, %{door_locks: [:lock_state, :get_lock_state, :lock_unlock_doors]}}

      iex> bin_2_caps = <<0x01>> <> <<0x01, 0x00, 0x02, 0x00, 0x20>> <> <<0x01, 0x00, 0x05, 0x00, 0x21, 0x00, 0x01, 0x02>>
      iex> AutoApi.CapabilityParser.to_map(bin_2_caps)
      {:ok, %{door_locks: [], trunk_access: [:get_trunk_state, :trunk_state, :open_close_trunk]}}

      iex> bin_invalid_caps = <<0x01>> <> <<0x01, 0x00, 0x02, 0x00, 0x20, 0x01>>
      iex> AutoApi.CapabilityParser.to_map(bin_invalid_caps)
      {:error, {:cannot_parse_data, <<1>>}}



      iex> bin_caps = <<0x1, 0x0, 0x20, 0x1, 0x1, 0x0, 0x25, 0x2, 0x0, 0x3>>
      iex> AutoApi.CapabilityParser.to_map(bin_caps)
      %{door_locks: [%{atom: :available, bin: <<1>>, name: "Available", title: ""}], rooftop: [%{bin: <<0x00>>, name: "Unavailable", atom: :unavailable, title: "Dimming"}, %{atom: :no_name, bin: <<0x3>>, name: "0% or 100% Available", title: "Open/Close"}]}
  """
  def to_map(<<0x01, 0x01, _::binary>> = bin_caps) do
    <<_msg_type, caps :: binary>> = bin_caps
    with caps_map when is_map(caps_map) <- bin_to_map_5(caps) do
      {:ok, caps_map}
    end
  end

  def to_map(bin_caps) do
    <<_cap_len, caps :: binary>> = bin_caps
    bin_to_map(caps)
  end

  defp bin_to_map_5(<<0x01, size::integer-16, capability::binary-size(size), rest_data::binary>>) do
    <<iden::binary-size(2), supported_actions::binary>> = capability
    with {_id, cap_module} <- find_cap_module_by_iden(iden),
         cap_name <- apply(cap_module, :name, []),
         actions_in_atom when is_list(actions_in_atom) <- supported_actions_to_atoms(cap_module, :binary.bin_to_list(supported_actions)),
         map_cap when is_map(map_cap) <- bin_to_map_5(rest_data) do
      Map.put(map_cap, cap_name, actions_in_atom)
    else
      nil -> {:error, {:invalid_iden, iden}}
      {:error, _} = error -> error
    end
  end
  defp bin_to_map_5(<<>>), do: %{}
  defp bin_to_map_5(data), do: {:error, {:cannot_parse_data, data}}

  defp supported_actions_to_atoms(cap_module, list_of_actions) do
    Enum.map list_of_actions, fn action ->
      apply(cap_module, :command_name, [action])
    end
  end

  defp bin_to_map(<<>>), do: %{}
  defp bin_to_map(<<iden::binary-size(2), size, cap_data::binary-size(size), rest_data::binary>>) do
    with {_id, cap_module} <- find_cap_module_by_iden(iden),
         cap_name <- apply(cap_module, :name, []),
         cap <- apply(cap_module, :to_map, [<<size>> <> cap_data]),
         map_cap when is_map(map_cap) <- bin_to_map(rest_data)
    do
      Map.put(map_cap, cap_name, cap)
    else
      nil -> {:error, {:invalid_iden, iden}}
      {:error, _} = error -> error
    end
  end

  defp find_cap_module_by_iden(iden) do
    Capability.list_capabilities
    |> Enum.filter(fn {id, _} -> id == iden end)
    |> List.first
  end

  @doc """
  Converts Capabilities to binary
      iex> map = %{door_locks: [%{atom: :available}], \
            rooftop: [%{atom: :available}, %{atom: :unavailable}]}
      iex> AutoApi.CapabilityParser.to_bin(map, :v4)
      <<0x02, 0x00, 0x20, 0x01, 0x01, 0x00, 0x25, 0x02, 0x01, 0x00>>
  """
  def to_bin(map, :v4) do
    name_to_module =
      Capability.list_capabilities
      |> Enum.map(fn {_id, cap_module} ->
        name = apply(cap_module, :name, [])
        {name, cap_module}
      end)
      |> Enum.into(%{})
    caps_list = Enum.map map, fn {cap_group, caps} ->
      cap_module = name_to_module[cap_group]
      cap_iden = apply(cap_module, :identifier, [])
      cap_len = length(caps)
      sub_caps = apply(cap_module, :capabilities, [])
      for index <- 0..cap_len-1 do
        %{atom: cap_atom} = Enum.at(caps, index)
        sub_caps
        |> Enum.at(index)
        |> Map.get(:options)
        |> Map.get(cap_atom)
        |> Map.get(:bin)
      end
      |> Enum.reduce((cap_iden <> <<cap_len>>), fn (i, x) -> x <> i end)
    end
    caps_length = length(caps_list)
    Enum.reduce(caps_list, <<caps_length>>, fn (i, x) -> x <> i end)
  end

  @doc """
  Converts capabilities version 5 to binary

    iex> map = %{door_locks: [], trunk_access: [:get_trunk_state, :trunk_state, :open_close_trunk]}
    iex> AutoApi.CapabilityParser.to_bin(map, :v5)
    <<0x01,   0x01, 0x00, 0x02, 0x00, 0x20,     0x01, 0x00, 0x05, 0x00, 0x21, 0x00, 0x01, 0x02>>
  """
  def to_bin(map, :v5) do
    name_to_module = cap_name_to_module()
    caps_list =
      map
      |> Enum.map(fn {cap_group, caps} -> padd_capabilities_bin(name_to_module[cap_group], caps) end)
      |> :binary.list_to_bin
    <<0x01>> <> caps_list
  end

  defp padd_capabilities_bin(cap_module, caps) do
    cap_bin = apply(cap_module, :to_bin, [caps])
    cap_len = byte_size(cap_bin)
    <<0x01, cap_len::integer-16, cap_bin::binary>>
  end

  defp cap_name_to_module do
    Capability.list_capabilities
    |> Enum.map(fn {_id, cap_module} ->
      name = apply(cap_module, :name, [])
      {name, cap_module}
    end)
    |> Enum.into(%{})
  end
end
