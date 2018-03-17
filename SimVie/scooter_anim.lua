local SheetInfo = {}

SheetInfo.sheet =
{
frames = {
{

   --Occurrence scooterTop 1
   x=96,
   y=5,
   width=21,
   height=33,
   sourceX=0,
   sourceY=0,
   sourceWidth=21,
   sourceHeight=33
},
{

   --Occurrence scooterTopSide 1
   x=5,
   y=43,
   width=26,
   height=31,
   sourceX=0,
   sourceY=0,
   sourceWidth=26,
   sourceHeight=31
},
{

   --Occurrence scooterDownSide 1
   x=29,
   y=5,
   width=26,
   height=30,
   sourceX=0,
   sourceY=0,
   sourceWidth=26,
   sourceHeight=30
},
{

   --Occurrence scooterSide 1
   x=60,
   y=5,
   width=31,
   height=32,
   sourceX=0,
   sourceY=0,
   sourceWidth=31,
   sourceHeight=32
},
{

   --Occurrence scooterDown 1
   x=5,
   y=5,
   width=19,
   height=33,
   sourceX=0,
   sourceY=0,
   sourceWidth=19,
   sourceHeight=33
},
 
},
sheetContentWidth = 128,
sheetContentHeight =80
}

SheetInfo.frameIndex =
{

["scooterTop"]={1},["scooterTopSide"]={2},["scooterDownSide"]={3},["scooterSide"]={4},["scooterDown"]={5},
}

SheetInfo.spriteIndex =
{
-- time=100,        -- Optional. In ms.  If not supplied, then sprite is frame-based.
-- loopCount = 0    -- Optional. Default is 0 (loop indefinitely)
-- loopDirection = "bounce"    -- Optional. Values include: "forward","bounce"
{name="scooterTop",frames={1},},
{name="scooterTopSide",frames={2},},
{name="scooterDownSide",frames={3},},
{name="scooterSide",frames={4},},
{name="scooterDown",frames={5},},

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