function shuffle(tbl)
    for i = 0,#tbl do
      local j = flr(rnd(i))
      tbl[i], tbl[j] = tbl[j], tbl[i]
    end
    return tbl
  end
  
  function perlin()
      local prl ={
          perm_size = 256,
          view_size = 18,
          text_view_size = 18,
          pixel_view_size = 130,
          pixel_mode = false,
          fmap = {},
          drawout={},
          dx = 0,
          dy = 0,
          old_dx = 0,
          old_dy = 0,
          permutation = {},
          p = {},
          init=function(self)
              for i=0,self.perm_size do
                  self.permutation[i] = i
              end
              self.permutation = shuffle(self.permutation)
              for i=1,self.perm_size do
                  self.p[i] = self.permutation[i]
                  self.p[self.perm_size+i] = self.p[i]
              end
          end,
          getmapdata=function(self,fromx,tox, fromy,toy)
              for y=fromy,toy do
                  if (self.fmap[y] == nil) self.fmap[y] = {}
                  for x=fromx,tox do
                      local nx = x/16 - 0.5
                      local ny = y/16 - 0.5
                      local v = ((self:noise(nx,ny,0)/ 2.0 + 0.5)*15)
                      local n = flr((v/15)*10)
                      self.fmap[y][x] = v
                  end
              end
          end,
         
          noise=function(self, x, y, z )
              local nx = flr(x) % self.perm_size
              local ny = flr(y) % self.perm_size
              local nz = flr(z) % self.perm_size
              x = x - flr(x)
              y = y - flr(y)
              z = z - flr(z)
              local u = fade(x)
              local v = fade(y)
              local w = fade(z)
  
              local a  = self.p[nx+1]+ny
              local aa = self.p[a+1]+nz
              local ab = self.p[a+2]+nz
              local b  = self.p[nx+2]+ny
              local ba = self.p[b+1]+nz
              local bb = self.p[b+2]+nz
  
              return lerp(w, lerp(v, lerp(u, grad(self.p[aa+1], x  , y  , z  ),
                                             grad(self.p[ba+1], x-1, y  , z  )),
                                     lerp(u, grad(self.p[ab+1], x  , y-1, z  ),
                                             grad(self.p[bb+1], x-1, y-1, z  ))),
                             lerp(v, lerp(u, grad(self.p[ab+2], x  , y  , z-1),
                                             grad(self.p[ba+2], x-1, y  , z-1)),
                                     lerp(u, grad(self.p[ab+2], x  , y-1, z-1),
                                             grad(self.p[bb+2], x-1, y-1, z-1))))
          end,
      }
      return prl
  end
  
  function fade( t )
      return t * t * t * (t * (t * 6 - 15) + 10)
  end
  
  function lerp( t, a, b )
      return a + t * (b - a)
  end
  
  function grad( hash, x, y, z )
      local h = hash % 16
      local u = h < 8 and x or y
      local v = h < 4 and y or ((h == 12 or h == 14) and x or z)
      return ((h % 2) == 0 and u or -u) + ((h % 3) == 0 and v or -v)
  end