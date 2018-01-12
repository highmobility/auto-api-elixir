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

      iex> bin_caps = <<0x1, 0x0, 0x20, 0x1, 0x1, 0x0, 0x25, 0x2, 0x0, 0x3>>
      iex> AutoApi.CapabilityParser.to_map(bin_caps)
      %{door_locks: [%{atom: :available, bin: <<1>>, name: "Available", title: ""}], rooftop: [%{bin: <<0x00>>, name: "Unavailable", atom: :unavailable, title: "Dimming"}, %{atom: :no_name, bin: <<0x3>>, name: "0% or 100% Available", title: "Open/Close"}]}
  """
  def to_map(bin_caps) do
    <<_cap_len, caps :: binary>> = bin_caps
    bin_to_map(caps)
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
      iex> AutoApi.CapabilityParser.to_bin(map)
      <<0x02, 0x00, 0x20, 0x01, 0x01, 0x00, 0x25, 0x02, 0x01, 0x00>>
  """
  def to_bin(map) do
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
end
