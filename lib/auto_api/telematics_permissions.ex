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
defmodule AutoApi.TelematicsPermissions do
  @permissions_map_properties Map.new(
                                for {_, cap} <- AutoApi.Capability.list_capabilities(),
                                    {id, prop} <- cap.properties,
                                    do: {"#{cap.name()}.#{prop}", %{type: :property, id: id}}
                              )

  @permissions_map_message_types Map.new(
                                   for {_, cap} <- AutoApi.Capability.list_capabilities(),
                                       {id, cmd} <- cap.commands,
                                       do:
                                         {"#{cap.name()}.#{cmd}", %{type: :message_type, id: id}}
                                 )

  @permissions_map Map.merge(@permissions_map_properties, @permissions_map_message_types)

  @permissions_list Map.keys(@permissions_map)

  @doc """
  Returns list of available permissions
    iex> "home_charger.authenticate_expire" in AutoApi.TelematicsPermissions.permissions_list()
    true
    iex> "race.accelerations" in AutoApi.TelematicsPermissions.permissions_list()
    true

  """
  @spec permissions_list :: list()
  def permissions_list do
    @permissions_list
  end

  @doc """
  Verifies that all permissions are valid car permissions

  ## Examples

    iex> AutoApi.TelematicsPermissions.verify ["race.accelerations", "home_charger.authenticate_expire"]
    true

    iex> AutoApi.TelematicsPermissions.verify ["charge.read", "i.dont.exist"]
    false

  """
  @spec verify(list(String.t())) :: boolean()
  def verify(properties) do
    Enum.empty?(properties -- permissions_list())
  end

  @doc """

    iex> AutoApi.TelematicsPermissions.to_sepc("race.accelerations")
    {:ok, %{id: 1, type: :property}}

    iex> AutoApi.TelematicsPermissions.to_sepc("home_charger.authenticate_expire")
    {:ok, %{id: 22, type: :message_type}}

    iex> AutoApi.TelematicsPermissions.to_sepc("i.dont.exist")
    :error
  """
  @spec to_sepc(String.t()) :: {:ok, %{type: :message_type | :property, id: integer}} | :error
  def to_sepc(property) do
    if spec = @permissions_map[property] do
      {:ok, spec}
    else
      :error
    end
  end
end
