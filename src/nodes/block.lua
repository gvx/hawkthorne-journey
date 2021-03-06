local Block = {}
Block.__index = Block

function Block.new(node, collider)
    local block = {}
    setmetatable(block, Block)
    block.bb = collider:addRectangle(node.x, node.y, node.width, node.height)
    block.bb.node = block
    collider:setPassive(block.bb)

    return block
end

function Block:collide(player, dt, mtv_x, mtv_y)
    local _, wy1, _, wy2  = self.bb:bbox()
    local _, _, _, py2 = player.bb:bbox()

    player.blocked_down =  math.abs(wy1 - py2) < 1
    player.blocked_up = py2 - wy2 > 0 and py2 - wy2 < 5

    if py2 < wy1 or py2 > wy2 or player.jumping then
        return
    end

    if mtv_y ~= 0 then
        player.velocity.y = 0
        player.position.y = player.position.y + mtv_y
    end

    if mtv_x ~= 0 then
        player.velocity.x = 0
        player.position.x = player.position.x + mtv_x
    end
end

function Block:collide_end(player, dt)
    player.blocked_up = false
    player.blocked_down = false
end


return Block

