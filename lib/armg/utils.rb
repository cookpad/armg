# see https://dev.mysql.com/doc/refman/5.7/en/gis-data-formats.html
module Armg::Utils
  def mysql_geometry_to_wkb(mysql_geometry)
    wkb = mysql_geometry.b
    srid = wkb.slice!(0..3)
    wkb[4] = "\x20"
    wkb.insert(5, srid)
  end
  module_function :mysql_geometry_to_wkb

  def pack_srid(srid)
    [srid].pack('L<')
  end
  module_function :pack_srid
end
