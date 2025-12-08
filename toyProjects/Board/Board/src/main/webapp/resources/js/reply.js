// Immediately-Invoked Function Expression (IIFE) to create a private module
var replyService = (function() {

    console.log("JS System =======================");
    
    /**
     * Add a new reply.
     * @param {Object} reply - Reply data object to send to the server.
     * @param {Function} [callback] - Called on success with the server result.
     * @param {Function} [error] - Called on failure with error info.
     */
    function add(reply, callback, error) {
        console.log("Add Reply =======================");
        $.ajax({
            type: 'post',
            url: '/replies/new',
            data: JSON.stringify(reply),
            contentType: "application/json; charset=utf-8",

            // Called when the server returns a successful HTTP status (2xx)
            success: function(result, status, xhr) {
                if (callback) { callback(result); }
            },

            // Called when the HTTP request itself fails or JSON parse fails
            error: function(xhr, status, er) {
                // Log where the error occurred
                console.log("Error occurred in add() function");
                // Log the HTTP status code (e.g. 400, 404, 500)
                console.log("Status Code:", xhr.status);
                // Log the error message (e.g. "Bad Request", "Internal Server Error")
                console.log("Error Message:", er);
                // Log any text returned by the server for debugging
                console.log("Server Response:", xhr.responseText);

                // If an error callback was provided, call it with the error info
                if (error) {
                    error(er);
                }
            }
        });
    }

    /**
     * Get a single reply by its id (rno).
     * @param {number} rno - Reply id (primary key).
     * @param {Function} [callback] - Called on success with the reply object.
     * @param {Function} [error] - Called on failure.
     */
     // Get a single reply by rno
	function get(rno, callback, error) {
	    $.get("/replies/" + rno + ".json", function(result) {
	        if (callback) { callback(result); }
	    }).fail(function(xhr, status, err) {
	        console.log("Error occurred in get() function");
	        console.log("Status Code:", xhr.status);
	        console.log("Error Message:", err);
	        console.log("Server Response:", xhr.responseText);
	        if (error) {
	            error(err);
	        }
	    });
	}

    /**
     * Get a paginated list of replies for a specific board (bno).
     * @param {Object} param - Contains bno and page information.
     * @param {number} param.bno - Board id.
     * @param {number} [param.page=1] - Page number (defaults to 1).
     * @param {Function} [callback] - Called on success with (replyCnt, list).
     * @param {Function} [error] - Called on failure.
     */
    // Get paginated list of replies for a board
	function getList(param, callback, error) {
	    console.log("getList =====================");
	
	    var bno = param.bno;
	    // Use the provided page or default to page 1
        // if param.page exist, it is assigned param.page.
        // else, param.page becomes null and is assigned 1.
	    var page = param.page || 1;
	
	    $.getJSON("/replies/pages/" + bno + "/" + page + ".json", function(data) {
	        if (callback) {
	            callback(data.replyCnt, data.list);
	        }
	    })
	    .fail(function(xhr, status, err) {
	        console.log("Error occurred in getList() function");
	        console.log("Status Code:", xhr.status);
	        console.log("Error Message:", err);
	        console.log("Server Response:", xhr.responseText);
	        if (error) {
	            error(err);
	        }
	    });
	}


    /**
     * Remove a reply by its id (rno).
     * @param {number} rno - Reply id to delete.
     * @param {Function} [callback] - Called on success with delete result text.
     * @param {Function} [error] - Called on failure with error info.
     */
	function remove(rno, callback, error) {
	    $.ajax({
	        type: 'delete',
	        url: '/replies/' + rno,
	        success: function(deleteResult, status, xhr) {
	            if (callback) { callback(deleteResult); }
	        },
	        error: function(xhr, status, er) {
	            console.log("Error occurred in remove() function");
	            console.log("Status Code:", xhr.status);
	            console.log("Error Message:", er);
	            console.log("Server Response:", xhr.responseText);
	            if (error) {
	                error(er);
	            }
	        }
	    });
	}


    /**
     * Update an existing reply.
     * @param {Object} reply - Updated reply data (must include rno).
     * @param {number} reply.rno - Id of the reply to update.
     * @param {Function} [callback] - Called on success with result text.
     * @param {Function} [error] - Called on failure with error info.
     */
	function update(reply, callback, error) {
	    console.log("RNO: " + reply.rno);
	
	    $.ajax({
	        type: 'put',
	        url: '/replies/' + reply.rno,
	        data: JSON.stringify(reply),
	        contentType: "application/json; charset=utf-8",
	        success: function(result, status, xhr) {
	            if (callback) {
	                callback(result);
	            }
	        },
	        error: function(xhr, status, er) {
	            console.log("Error occurred in update() function");
	            console.log("Status Code:", xhr.status);
	            console.log("Error Message:", er);
	            console.log("Server Response:", xhr.responseText);
	            if (error) {
	                error(er);
	            }
	        }
	    });
	}


    /**
	 * Format a timestamp into a human-readable string.
	 * If the time is within the last 24 hours, show "HH:MM:SS".
	 * Otherwise, show "YYYY/MM/DD".
	 *
	 * @param {number} timeValue - Millisecond timestamp (e.g. from Date.getTime()).
	 * @returns {string} - Formatted time string.
	 */
	function displayTime(timeValue) {
	    // Current date/time on the client
	    var today = new Date();
	
	    // Difference between now and the given time, in milliseconds
	    // Date.getTime() returns milliseconds since 1970-01-01 UTC. [web:237]
	    var gap = today.getTime() - timeValue;
	
	    // Convert the given timestamp into a Date object
	    var dateObj = new Date(timeValue);
	
	    // String that will hold the final formatted result
	    var str = "";
	
	    // If the time is within the last 24 hours (1000 ms * 60 sec * 60 min * 24 hr)
	    if (gap < (1000 * 60 * 60 * 24)) {
	
	        // Extract hour, minute, second
	        var hh = dateObj.getHours();
	        var mi = dateObj.getMinutes();
	        var ss = dateObj.getSeconds();
	
	        // Return "HH:MM:SS" with leading zeros (e.g. 09:05:03)
	        return [
	            (hh > 9 ? '' : '0') + hh,
	            ':',
	            (mi > 9 ? '' : '0') + mi,
	            ':',
	            (ss > 9 ? '' : '0') + ss
	        ].join('');
	    } else {
	        // For older dates, show year/month/day
	
	        var yy = dateObj.getFullYear();
	        var mm = dateObj.getMonth() + 1; // getMonth() is zero-based, so add 1
	        var dd = dateObj.getDate();
	
	        // Return "YYYY/MM/DD" with leading zeros on month and day
	        return [
	            yy,
	            '/',
	            (mm > 9 ? '' : '0') + mm,
	            '/',
	            (dd > 9 ? '' : '0') + dd
	        ].join('');
	    } // end of if-else
	}

	
	    // Expose public API of the replyService module
	    return {
	        add: add,
	        get: get,
	        getList: getList,
	        remove: remove,
	        update: update,
	        displayTime: displayTime
	    };
	})();
