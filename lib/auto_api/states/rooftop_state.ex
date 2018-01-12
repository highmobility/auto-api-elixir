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
defmodule AutoApi.RooftopState do
  defstruct dimming: 0, open: 0

  use AutoApi.State

  @type t :: %{dimming: integer, open: integer}

  @spec from_bin(binary) :: t
  def from_bin(<<dimming, open>>) do
    %__MODULE__{dimming: dimming, open: open}
  end

  @spec to_bin(t) :: binary
  def to_bin(%__MODULE__{} = struct) do
    <<struct.dimming, struct.open>>
  end
end
