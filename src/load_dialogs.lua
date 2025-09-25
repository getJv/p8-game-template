-- load dialogs
function load_dialogs()
    dialog_create(
            "initial_chat",
            [[
                actor_id=store_man;speech=hello there!
                actor_id=player;speech=hey hey!
                actor_id=player;speech=show me what you have today!
            ]]
    )
end