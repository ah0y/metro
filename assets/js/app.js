// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"
import css from '../css/app.css';
import LiveSocket from "phoenix_live_view"


if (document.querySelector("meta[name=user_token]")) {


    const liveSocket = new LiveSocket("/live",
        {
            params: {
                token: document.querySelector("meta[name=user_token]").content
            }
        })
    liveSocket.connect()

// let socket = new Socket("/socket", {params: {token: window.userToken}})

// let socket = null;

    let userId = window.userId;

    // socket.connect();

    let channel = liveSocket.channel(`notifications:${userId}`, {});
    // channel.join()
    //     .receive("ok", resp => {
    //         console.log("Joined successfully", resp)
    //         console.log(socket)
    //     })
    //     .receive("error", resp => {
    //         console.log("Unable to join", resp)
    //     });

    channel.on('new_notification', payload => {
        console.log("ding");
        console.log(payload)
        document.getElementById("noti_Counter").innerHTML = parseInt(document.getElementById("noti_Counter").innerHTML) + 1
    });
}


$('[data-toggle="collapse"]').on('click', function () {
    $(this).toggleClass('collapsed');
});

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"
