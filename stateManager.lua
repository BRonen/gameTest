local sm = {}
sm.game = require('scenes.game')
sm.teste = require('scenes.teste')

function sm.switch(scene)
    for i, v in pairs(sm[scene]) do
        print('loading: '..scene..'...\n\t', i, v)
        love[i] = v
    end
end

return sm