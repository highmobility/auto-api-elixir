# AutoAPI
# The MIT License
#
# Copyright (c) 2018- High-Mobility GmbH (https://high-mobility.com)
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
defmodule AutoApiL12.TelematicsPermissions do
  @moduledoc """
  Utility module for handling AutoApiL12 telematics permissions.

  """
  @permissions_map for cap <- AutoApiL12.Capability.all(),
                       {id, prop} <- cap.properties(),
                       action <- [:set, :get],
                       into: %{},
                       do: {"#{cap.name()}.#{action}.#{prop}", %{type: :property, id: id}}

  @permissions_list Map.keys(@permissions_map)

  @doc """
  Returns list of available permissions
    iex> "home_charger.set.wi_fi_hotspot_password" in AutoApiL12.TelematicsPermissions.permissions_list()
    true
    iex> "home_charger.get.wi_fi_hotspot_password" in AutoApiL12.TelematicsPermissions.permissions_list()
    true
  """
  @spec permissions_list :: list()
  def permissions_list do
    @permissions_list
  end

  @doc """
  Verifies that all permissions are valid car permissions

  # Examples

  iex> AutoApiL12.TelematicsPermissions.verify ["race.set.accelerations", "usage.get.average_weekly_distance_long_run"]
  true

  iex> AutoApiL12.TelematicsPermissions.verify ["charge.read", "i.dont.exist"]
  false

  """
  @spec verify(list(String.t())) :: boolean()
  def verify(properties) do
    Enum.empty?(properties -- permissions_list())
  end

  @doc """
  Converts a permissions format string to property id

  iex> AutoApiL12.TelematicsPermissions.to_spec("race.get.accelerations")
  {:ok, %{id: 1, type: :property}}

  iex> AutoApiL12.TelematicsPermissions.to_spec("i.dont.exist")
  :error
  """
  @spec to_spec(String.t()) :: {:ok, %{type: :property, id: integer}} | :error
  def to_spec(property) do
    if spec = @permissions_map[property] do
      {:ok, spec}
    else
      :error
    end
  end

  @doc """
  Extracts only the capabilities granted from the given set of permissions.

  Raises ArgumentError if one of the permissions is invalid.

  ## Examples

  iex> AutoApiL12.TelematicsPermissions.capabilities ["race.set.accelerations", "usage.get.average_weekly_distance_long_run", "race.get.gear_mode"]
  [AutoApiL12.RaceCapability, AutoApiL12.UsageCapability]

  iex> AutoApiL12.TelematicsPermissions.capabilities ["charging.get.status", "i.dont.exist"]
  ** (ArgumentError) non existing properties: ["i.dont.exist"]
  """
  @spec capabilities(list(String.t())) :: list(AutoApiL12.Capability.t()) | no_return()
  def capabilities(permissions) do
    case permissions -- @permissions_list do
      [] ->
        permissions
        |> Enum.map(&String.split(&1, "."))
        |> Enum.map(&List.first/1)
        |> Enum.uniq()
        |> Enum.map(&AutoApiL12.Capability.get_by_name/1)

      wrong_properties ->
        raise ArgumentError, "non existing properties: #{inspect(wrong_properties)}"
    end
  end
end
