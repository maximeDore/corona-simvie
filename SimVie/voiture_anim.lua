local SheetInfo = {}

SheetInfo.sheet =
{
frames = {
{

   --Occurrence autoTopSide 1
   x=175,
   y=5,
   width=44,
   height=46,
   sourceX=0,
   sourceY=0,
   sourceWidth=44,
   sourceHeight=46
},
{

   --Occurrence autoTop 1
   x=145,
   y=5,
   width=25,
   height=46,
   sourceX=0,
   sourceY=0,
   sourceWidth=25,
   sourceHeight=46
},
{

   --Occurrence autoSide 1
   x=84,
   y=5,
   width=56,
   height=33,
   sourceX=0,
   sourceY=0,
   sourceWidth=56,
   sourceHeight=33
},
{

   --Occurrence autoDown 1
   x=5,
   y=5,
   width=24,
   height=46,
   sourceX=0,
   sourceY=0,
   sourceWidth=24,
   sourceHeight=46
},
{

   --Occurrence autoDownSide 1
   x=34,
   y=5,
   width=45,
   height=44,
   sourceX=0,
   sourceY=0,
   sourceWidth=45,
   sourceHeight=44
},
 
},
sheetContentWidth = 256,
sheetContentHeight =68
}

SheetInfo.frameIndex =
{

["voitureTopSide"]={1},["voitureTop"]={2},["voitureSide"]={3},["voitureDown"]={4},["voitureDownSide"]={5},
}

SheetInfo.spriteIndex =
{
-- time=100,        -- Optional. In ms.  If not supplied, then sprite is frame-based.
-- loopCount = 0    -- Optional. Default is 0 (loop indefinitely)
-- loopDirection = "bounce"    -- Optional. Values include: "forward","bounce"
{name="voitureTopSide",frames={1},},
{name="voitureTop",frames={2},},
{name="voitureSide",frames={3},},
{name="voitureDown",frames={4},},
{name="voitureDownSide",frames={5},},

}

function SheetInfo:getSheet()
return self.sheet;
end

function SheetInfo:getFrameIndex(name)
return self.frameIndex[name];
end

function SheetInfo:getSpriteIndex()
  return self.spriteIndex;
end


return SheetInfo