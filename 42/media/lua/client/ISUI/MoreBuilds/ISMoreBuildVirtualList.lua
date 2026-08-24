require 'ISUI/ISScrollingListBox'

ISMoreBuildVirtualList = ISScrollingListBox:derive('ISMoreBuildVirtualList')

function ISMoreBuildVirtualList:rowAt(x, y)
  local index = math.floor(y / self.itemheight) + 1
  if index > 0 and index <= #self.items then return index end
  return -1
end

function ISMoreBuildVirtualList:topOfItem(index)
  if index > 0 and index <= #self.items then return (index - 1) * self.itemheight end
  return -1
end

function ISMoreBuildVirtualList:prevVisibleIndex(index)
  if index > 1 then return index - 1 end
  return -1
end

function ISMoreBuildVirtualList:nextVisibleItem(index)
  if index < #self.items then return index + 1 end
  return -1
end

ISMoreBuildVirtualList.nextVisibleIndex = ISMoreBuildVirtualList.nextVisibleItem

function ISMoreBuildVirtualList:ensureVisible(index)
  if index < 1 or index > #self.items then return end
  local y = self:topOfItem(index)
  if not self.smoothScrollTargetY then self.smoothScrollY = self:getYScroll() end
  if y <= -self:getYScroll() then
    self.smoothScrollTargetY = -y
  elseif y + self.itemheight > -self:getYScroll() + self.height then
    self.smoothScrollTargetY = -(y + self.itemheight - self.height)
  end
end

function ISMoreBuildVirtualList:prerender()
  if self.items == nil then return end
  local listHeight = #self.items * self.itemheight
  if self.listHeight ~= listHeight then
    self.listHeight = listHeight
    self:setScrollHeight(listHeight)
  end
  local stencilX, stencilY, stencilX2, stencilY2 = 0, 0, self.width, self.height
  self:drawRect(0, -self:getYScroll(), self.width, self.height, self.backgroundColor.a, self.backgroundColor.r, self.backgroundColor.g, self.backgroundColor.b)
  if self.drawBorder then
    self:drawRectBorder(0, -self:getYScroll(), self.width, self.height, self.borderColor.a, self.borderColor.r, self.borderColor.g, self.borderColor.b)
    stencilX, stencilY, stencilX2, stencilY2 = 1, 1, self.width - 1, self.height - 1
  end
  if self:isVScrollBarVisible() then stencilX2 = self.vscroll.x + 3 end
  if self:parentsHaveScrollChildren() then
    stencilX = self.javaObject:clampToParentX(self:getAbsoluteX() + stencilX) - self:getAbsoluteX()
    stencilX2 = self.javaObject:clampToParentX(self:getAbsoluteX() + stencilX2) - self:getAbsoluteX()
    stencilY = self.javaObject:clampToParentY(self:getAbsoluteY() + stencilY) - self:getAbsoluteY()
    stencilY2 = self.javaObject:clampToParentY(self:getAbsoluteY() + stencilY2) - self:getAbsoluteY()
  end
  self:setStencilRect(stencilX, stencilY, stencilX2 - stencilX, stencilY2 - stencilY)
  if self.selected ~= -1 and self.selected > #self.items then self.selected = #self.items end
  local top = math.max(0, -self:getYScroll())
  local firstIndex = math.floor(top / self.itemheight) + 1
  local lastIndex = math.min(#self.items, math.ceil((top + self.height) / self.itemheight) + 1)
  if self.onVisibleRangeChanged and (self.visibleFirstIndex ~= firstIndex or self.visibleLastIndex ~= lastIndex) then
    self.visibleFirstIndex, self.visibleLastIndex = firstIndex, lastIndex
    self:onVisibleRangeChanged(firstIndex, lastIndex)
  end
  local y = (firstIndex - 1) * self.itemheight
  for index = firstIndex, lastIndex do
    local item = self.items[index]
    item.index, item.height = index, self.itemheight
    local alt = index % 2 == 0
    if alt and self.altBgColor then self:drawRect(0, y, self:getWidth(), self.itemheight - 1, self.altBgColor.r, self.altBgColor.g, self.altBgColor.b, self.altBgColor.a) end
    self:doDrawItem(y, item, alt)
    y = y + self.itemheight
  end
  self:clearStencilRect()
  if self.doRepaintStencil then self:repaintStencilRect(stencilX, stencilY, stencilX2 - stencilX, stencilY2 - stencilY) end
  local mouseY = self:getMouseY()
  self:updateSmoothScrolling()
  if mouseY ~= self:getMouseY() and self:isMouseOver() then self:onMouseMove(0, self:getMouseY() - mouseY) end
  self:updateTooltip()
  if self.useStencilForChildren then self:setStencilRect(0, 0, self.width, self.height) end
end

function ISMoreBuildVirtualList:new(x, y, width, height)
  return ISScrollingListBox.new(self, x, y, width, height)
end

