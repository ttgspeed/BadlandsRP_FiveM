local cbs = {
    ['tent'] = vRP.resolveTentRobbery
}

function tvRP.resolveRobbery(success,cb,cbargs)
    cbs[cb](source,success,cbargs)
end
