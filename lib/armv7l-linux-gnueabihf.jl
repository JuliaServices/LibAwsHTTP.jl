using CEnum

# typedef void ( aws_http_on_client_connection_setup_fn ) ( struct aws_http_connection * connection , int error_code , void * user_data )
"""
Invoked when connect completes.

If unsuccessful, error\\_code will be set, connection will be NULL, and the on\\_shutdown callback will never be invoked.

If successful, error\\_code will be 0 and connection will be valid. The user is now responsible for the connection and must call [`aws_http_connection_release`](@ref)() when they are done with it.

The connection uses one event-loop thread to do all its work. The thread invoking this callback will be the same thread that invokes all future callbacks for this connection and its streams.
"""
const aws_http_on_client_connection_setup_fn = Cvoid

# typedef void ( aws_http_on_client_connection_shutdown_fn ) ( struct aws_http_connection * connection , int error_code , void * user_data )
"""
Invoked when the connection has finished shutting down. Never invoked if on\\_setup failed. This is always invoked on connection's event-loop thread. Note that the connection is not completely done until on\\_shutdown has been invoked AND [`aws_http_connection_release`](@ref)() has been called.
"""
const aws_http_on_client_connection_shutdown_fn = Cvoid

# typedef void ( aws_http2_on_change_settings_complete_fn ) ( struct aws_http_connection * http2_connection , int error_code , void * user_data )
"""
Invoked when the HTTP/2 settings change is complete. If connection setup successfully this will always be invoked whether settings change successfully or unsuccessfully. If error\\_code is AWS\\_ERROR\\_SUCCESS (0), then the peer has acknowledged the settings and the change has been applied. If error\\_code is non-zero, then a connection error occurred before the settings could be fully acknowledged and applied. This is always invoked on the connection's event-loop thread.
"""
const aws_http2_on_change_settings_complete_fn = Cvoid

# typedef void ( aws_http2_on_ping_complete_fn ) ( struct aws_http_connection * http2_connection , uint64_t round_trip_time_ns , int error_code , void * user_data )
"""
Invoked when the HTTP/2 PING completes, whether peer has acknowledged it or not. If error\\_code is AWS\\_ERROR\\_SUCCESS (0), then the peer has acknowledged the PING and round\\_trip\\_time\\_ns will be the round trip time in nano seconds for the connection. If error\\_code is non-zero, then a connection error occurred before the PING get acknowledgment and round\\_trip\\_time\\_ns will be useless in this case.
"""
const aws_http2_on_ping_complete_fn = Cvoid

# typedef void ( aws_http2_on_goaway_received_fn ) ( struct aws_http_connection * http2_connection , uint32_t last_stream_id , uint32_t http2_error_code , struct aws_byte_cursor debug_data , void * user_data )
"""
Invoked when an HTTP/2 GOAWAY frame is received from peer. Implies that the peer has initiated shutdown, or encountered a serious error. Once a GOAWAY is received, no further streams may be created on this connection.

# Arguments
* `http2_connection`: This HTTP/2 connection.
* `last_stream_id`: ID of the last locally-initiated stream that peer will process. Any locally-initiated streams with a higher ID are ignored by peer, and are safe to retry on another connection.
* `http2_error_code`: The HTTP/2 error code (RFC-7540 section 7) sent by peer. `enum [`aws_http2_error_code`](@ref)` lists official codes.
* `debug_data`: The debug data sent by peer. It can be empty. (NOTE: this data is only valid for the lifetime of the callback. Make a deep copy if you wish to keep it longer.)
* `user_data`: User-data passed to the callback.
"""
const aws_http2_on_goaway_received_fn = Cvoid

# typedef void ( aws_http2_on_remote_settings_change_fn ) ( struct aws_http_connection * http2_connection , const struct aws_http2_setting * settings_array , size_t num_settings , void * user_data )
"""
Invoked when new HTTP/2 settings from peer have been applied. Settings\\_array is the array of aws\\_http2\\_settings that contains all the settings we just changed in the order we applied (the order settings arrived). Num\\_settings is the number of elements in that array.
"""
const aws_http2_on_remote_settings_change_fn = Cvoid

# typedef void ( aws_http_statistics_observer_fn ) ( size_t connection_nonce , const struct aws_array_list * stats_list , void * user_data )
"""
Callback invoked on each statistics sample.

connection\\_nonce is unique to each connection for disambiguation of each callback per connection.
"""
const aws_http_statistics_observer_fn = Cvoid

"""
    aws_http_connection_monitoring_options

Configuration options for connection monitoring
"""
struct aws_http_connection_monitoring_options
    minimum_throughput_bytes_per_second::UInt64
    allowable_throughput_failure_interval_seconds::UInt32
    statistics_observer_fn::Ptr{aws_http_statistics_observer_fn}
    statistics_observer_user_data::Ptr{Cvoid}
end

"""
    aws_http1_connection_options

Options specific to HTTP/1.x connections.
"""
struct aws_http1_connection_options
    read_buffer_capacity::Csize_t
end

"""
    aws_http2_settings_id

Documentation not found.
"""
@cenum aws_http2_settings_id::UInt32 begin
    AWS_HTTP2_SETTINGS_BEGIN_RANGE = 1
    AWS_HTTP2_SETTINGS_HEADER_TABLE_SIZE = 1
    AWS_HTTP2_SETTINGS_ENABLE_PUSH = 2
    AWS_HTTP2_SETTINGS_MAX_CONCURRENT_STREAMS = 3
    AWS_HTTP2_SETTINGS_INITIAL_WINDOW_SIZE = 4
    AWS_HTTP2_SETTINGS_MAX_FRAME_SIZE = 5
    AWS_HTTP2_SETTINGS_MAX_HEADER_LIST_SIZE = 6
    AWS_HTTP2_SETTINGS_END_RANGE = 7
end

"""
    aws_http2_setting

Documentation not found.
"""
struct aws_http2_setting
    id::aws_http2_settings_id
    value::UInt32
end

"""
    aws_http2_connection_options

Options specific to HTTP/2 connections.
"""
struct aws_http2_connection_options
    initial_settings_array::Ptr{aws_http2_setting}
    num_initial_settings::Csize_t
    on_initial_settings_completed::Ptr{aws_http2_on_change_settings_complete_fn}
    max_closed_streams::Csize_t
    on_goaway_received::Ptr{aws_http2_on_goaway_received_fn}
    on_remote_settings_change::Ptr{aws_http2_on_remote_settings_change_fn}
    conn_manual_window_management::Bool
    conn_window_size_threshold_to_send_update::UInt32
    stream_window_size_threshold_to_send_update::UInt32
end

"""
    aws_http_proxy_connection_type

Supported proxy connection types
"""
@cenum aws_http_proxy_connection_type::UInt32 begin
    AWS_HPCT_HTTP_LEGACY = 0
    AWS_HPCT_HTTP_FORWARD = 1
    AWS_HPCT_HTTP_TUNNEL = 2
end

# typedef struct aws_http_proxy_negotiator * ( aws_http_proxy_strategy_create_negotiator_fn ) ( struct aws_http_proxy_strategy * proxy_strategy , struct aws_allocator * allocator )
"""
******************************************************************************************
"""
const aws_http_proxy_strategy_create_negotiator_fn = Cvoid

"""
    aws_http_proxy_strategy_vtable

Documentation not found.
"""
struct aws_http_proxy_strategy_vtable
    create_negotiator::Ptr{aws_http_proxy_strategy_create_negotiator_fn}
end

"""
    aws_http_proxy_strategy

Documentation not found.
"""
struct aws_http_proxy_strategy
    ref_count::aws_ref_count
    vtable::Ptr{aws_http_proxy_strategy_vtable}
    impl::Ptr{Cvoid}
    proxy_connection_type::aws_http_proxy_connection_type
end

"""
    aws_http_proxy_authentication_type

!!! compat "Deprecated"

    - Supported proxy authentication modes. Superceded by proxy strategy.
"""
@cenum aws_http_proxy_authentication_type::UInt32 begin
    AWS_HPAT_NONE = 0
    AWS_HPAT_BASIC = 1
end

"""
    aws_http_proxy_options

Options for http proxy server usage
"""
struct aws_http_proxy_options
    connection_type::aws_http_proxy_connection_type
    host::aws_byte_cursor
    port::UInt32
    tls_options::Ptr{aws_tls_connection_options}
    proxy_strategy::Ptr{aws_http_proxy_strategy}
    auth_type::aws_http_proxy_authentication_type
    auth_username::aws_byte_cursor
    auth_password::aws_byte_cursor
end

"""
    aws_http_proxy_env_var_type

Documentation not found.
"""
@cenum aws_http_proxy_env_var_type::UInt32 begin
    AWS_HPEV_DISABLE = 0
    AWS_HPEV_ENABLE = 1
end

"""
    proxy_env_var_settings

Documentation not found.
"""
struct proxy_env_var_settings
    env_var_type::aws_http_proxy_env_var_type
    connection_type::aws_http_proxy_connection_type
    tls_options::Ptr{aws_tls_connection_options}
end

"""
    aws_http_client_connection_options

Options for creating an HTTP client connection. Initialize with `AWS_HTTP_CLIENT_CONNECTION_OPTIONS_INIT` to set default values.
"""
struct aws_http_client_connection_options
    self_size::Csize_t
    allocator::Ptr{aws_allocator}
    bootstrap::Ptr{aws_client_bootstrap}
    host_name::aws_byte_cursor
    port::UInt32
    socket_options::Ptr{aws_socket_options}
    tls_options::Ptr{aws_tls_connection_options}
    proxy_options::Ptr{aws_http_proxy_options}
    proxy_ev_settings::Ptr{proxy_env_var_settings}
    monitoring_options::Ptr{aws_http_connection_monitoring_options}
    response_first_byte_timeout_ms::UInt64
    manual_window_management::Bool
    initial_window_size::Csize_t
    user_data::Ptr{Cvoid}
    on_setup::Ptr{aws_http_on_client_connection_setup_fn}
    on_shutdown::Ptr{aws_http_on_client_connection_shutdown_fn}
    prior_knowledge_http2::Bool
    alpn_string_map::Ptr{aws_hash_table}
    http1_options::Ptr{aws_http1_connection_options}
    http2_options::Ptr{aws_http2_connection_options}
    requested_event_loop::Ptr{aws_event_loop}
    host_resolution_config::Ptr{aws_host_resolution_config}
end

"""
    aws_http_client_connect(options)

Asynchronously establish a client connection. The on\\_setup callback is invoked when the operation has created a connection or failed.

### Prototype
```c
int aws_http_client_connect(const struct aws_http_client_connection_options *options);
```
"""
function aws_http_client_connect(options)
    ccall((:aws_http_client_connect, libaws_c_http), Cint, (Ptr{aws_http_client_connection_options},), options)
end

"""
Documentation not found.
"""
mutable struct aws_http_connection end

"""
    aws_http_connection_release(connection)

Users must release the connection when they are done with it. The connection's memory cannot be reclaimed until this is done. If the connection was not already shutting down, it will be shut down.

Users should always wait for the on\\_shutdown() callback to be called before releasing any data passed to the http\\_connection (Eg `aws_tls_connection_options`, `aws_socket_options`) otherwise there will be race conditions between http\\_connection shutdown tasks and memory release tasks, causing Segfaults.

### Prototype
```c
void aws_http_connection_release(struct aws_http_connection *connection);
```
"""
function aws_http_connection_release(connection)
    ccall((:aws_http_connection_release, libaws_c_http), Cvoid, (Ptr{aws_http_connection},), connection)
end

"""
    aws_http_connection_close(connection)

Begin shutdown sequence of the connection if it hasn't already started. This will schedule shutdown tasks on the EventLoop that may send HTTP/TLS/TCP shutdown messages to peers if necessary, and will eventually cause internal connection memory to stop being accessed and on\\_shutdown() callback to be called.

It's safe to call this function regardless of the connection state as long as you hold a reference to the connection.

### Prototype
```c
void aws_http_connection_close(struct aws_http_connection *connection);
```
"""
function aws_http_connection_close(connection)
    ccall((:aws_http_connection_close, libaws_c_http), Cvoid, (Ptr{aws_http_connection},), connection)
end

"""
    aws_http_connection_stop_new_requests(connection)

Stop accepting new requests for the connection. It will NOT start the shutdown process for the connection. The requests that are already open can still wait to be completed, but new requests will fail to be created,

### Prototype
```c
void aws_http_connection_stop_new_requests(struct aws_http_connection *connection);
```
"""
function aws_http_connection_stop_new_requests(connection)
    ccall((:aws_http_connection_stop_new_requests, libaws_c_http), Cvoid, (Ptr{aws_http_connection},), connection)
end

"""
    aws_http_connection_is_open(connection)

Returns true unless the connection is closed or closing.

### Prototype
```c
bool aws_http_connection_is_open(const struct aws_http_connection *connection);
```
"""
function aws_http_connection_is_open(connection)
    ccall((:aws_http_connection_is_open, libaws_c_http), Bool, (Ptr{aws_http_connection},), connection)
end

"""
    aws_http_connection_new_requests_allowed(connection)

Return whether the connection can make a new requests. If false, then a new connection must be established to make further requests.

### Prototype
```c
bool aws_http_connection_new_requests_allowed(const struct aws_http_connection *connection);
```
"""
function aws_http_connection_new_requests_allowed(connection)
    ccall((:aws_http_connection_new_requests_allowed, libaws_c_http), Bool, (Ptr{aws_http_connection},), connection)
end

"""
    aws_http_connection_is_client(connection)

Returns true if this is a client connection.

### Prototype
```c
bool aws_http_connection_is_client(const struct aws_http_connection *connection);
```
"""
function aws_http_connection_is_client(connection)
    ccall((:aws_http_connection_is_client, libaws_c_http), Bool, (Ptr{aws_http_connection},), connection)
end

"""
    aws_http_version

Documentation not found.
"""
@cenum aws_http_version::UInt32 begin
    AWS_HTTP_VERSION_UNKNOWN = 0
    AWS_HTTP_VERSION_1_0 = 1
    AWS_HTTP_VERSION_1_1 = 2
    AWS_HTTP_VERSION_2 = 3
    AWS_HTTP_VERSION_COUNT = 4
end

"""
    aws_http_connection_get_version(connection)

Documentation not found.
### Prototype
```c
enum aws_http_version aws_http_connection_get_version(const struct aws_http_connection *connection);
```
"""
function aws_http_connection_get_version(connection)
    ccall((:aws_http_connection_get_version, libaws_c_http), aws_http_version, (Ptr{aws_http_connection},), connection)
end

"""
    aws_http_connection_get_channel(connection)

Returns the channel hosting the HTTP connection. Do not expose this function to language bindings.

### Prototype
```c
struct aws_channel *aws_http_connection_get_channel(struct aws_http_connection *connection);
```
"""
function aws_http_connection_get_channel(connection)
    ccall((:aws_http_connection_get_channel, libaws_c_http), Ptr{Cvoid}, (Ptr{aws_http_connection},), connection)
end

"""
    aws_http_connection_get_remote_endpoint(connection)

Returns the remote endpoint of the HTTP connection.

### Prototype
```c
const struct aws_socket_endpoint *aws_http_connection_get_remote_endpoint(const struct aws_http_connection *connection);
```
"""
function aws_http_connection_get_remote_endpoint(connection)
    ccall((:aws_http_connection_get_remote_endpoint, libaws_c_http), Ptr{aws_socket_endpoint}, (Ptr{aws_http_connection},), connection)
end

"""
    aws_http_alpn_map_init_copy(allocator, dest, src)

Initialize an map copied from the *src map, which maps `struct aws\\_string *` to `enum [`aws_http_version`](@ref)`.

### Prototype
```c
int aws_http_alpn_map_init_copy( struct aws_allocator *allocator, struct aws_hash_table *dest, struct aws_hash_table *src);
```
"""
function aws_http_alpn_map_init_copy(allocator, dest, src)
    ccall((:aws_http_alpn_map_init_copy, libaws_c_http), Cint, (Ptr{aws_allocator}, Ptr{aws_hash_table}, Ptr{aws_hash_table}), allocator, dest, src)
end

"""
    aws_http_alpn_map_init(allocator, map)

Initialize an empty hash-table that maps `struct aws\\_string *` to `enum [`aws_http_version`](@ref)`. This map can used in aws\\_http\\_client\\_connections\\_options.alpn\\_string\\_map.

### Prototype
```c
int aws_http_alpn_map_init(struct aws_allocator *allocator, struct aws_hash_table *map);
```
"""
function aws_http_alpn_map_init(allocator, map)
    ccall((:aws_http_alpn_map_init, libaws_c_http), Cint, (Ptr{aws_allocator}, Ptr{aws_hash_table}), allocator, map)
end

"""
    aws_http_options_validate_proxy_configuration(options)

Checks http proxy options for correctness

### Prototype
```c
int aws_http_options_validate_proxy_configuration(const struct aws_http_client_connection_options *options);
```
"""
function aws_http_options_validate_proxy_configuration(options)
    ccall((:aws_http_options_validate_proxy_configuration, libaws_c_http), Cint, (Ptr{aws_http_client_connection_options},), options)
end

"""
    aws_http2_connection_change_settings(http2_connection, settings_array, num_settings, on_completed, user_data)

Send a SETTINGS frame (HTTP/2 only). SETTINGS will be applied locally when SETTINGS ACK is received from peer.

# Arguments
* `http2_connection`: HTTP/2 connection.
* `settings_array`: The array of settings to change. Note: each setting has its boundary.
* `num_settings`: The num of settings to change in settings\\_array.
* `on_completed`: Optional callback, see [`aws_http2_on_change_settings_complete_fn`](@ref).
* `user_data`: User-data pass to on\\_completed callback.
### Prototype
```c
int aws_http2_connection_change_settings( struct aws_http_connection *http2_connection, const struct aws_http2_setting *settings_array, size_t num_settings, aws_http2_on_change_settings_complete_fn *on_completed, void *user_data);
```
"""
function aws_http2_connection_change_settings(http2_connection, settings_array, num_settings, on_completed, user_data)
    ccall((:aws_http2_connection_change_settings, libaws_c_http), Cint, (Ptr{aws_http_connection}, Ptr{aws_http2_setting}, Csize_t, Ptr{aws_http2_on_change_settings_complete_fn}, Ptr{Cvoid}), http2_connection, settings_array, num_settings, on_completed, user_data)
end

"""
    aws_http2_connection_ping(http2_connection, optional_opaque_data, on_completed, user_data)

Send a PING frame (HTTP/2 only). Round-trip-time is calculated when PING ACK is received from peer.

# Arguments
* `http2_connection`: HTTP/2 connection.
* `optional_opaque_data`: Optional payload for PING frame. Must be NULL, or exactly 8 bytes ([`AWS_HTTP2_PING_DATA_SIZE`](@ref)). If NULL, the 8 byte payload will be all zeroes.
* `on_completed`: Optional callback, invoked when PING ACK is received from peer, or when a connection error prevents the PING ACK from being received. Callback always fires on the connection's event-loop thread.
* `user_data`: User-data pass to on\\_completed callback.
### Prototype
```c
int aws_http2_connection_ping( struct aws_http_connection *http2_connection, const struct aws_byte_cursor *optional_opaque_data, aws_http2_on_ping_complete_fn *on_completed, void *user_data);
```
"""
function aws_http2_connection_ping(http2_connection, optional_opaque_data, on_completed, user_data)
    ccall((:aws_http2_connection_ping, libaws_c_http), Cint, (Ptr{aws_http_connection}, Ptr{aws_byte_cursor}, Ptr{aws_http2_on_ping_complete_fn}, Ptr{Cvoid}), http2_connection, optional_opaque_data, on_completed, user_data)
end

"""
    aws_http2_connection_get_local_settings(http2_connection, out_settings)

Get the local settings we are using to affect the decoding.

# Arguments
* `http2_connection`: HTTP/2 connection.
* `out_settings`: fixed size array of [`aws_http2_setting`](@ref) gets set to the local settings
### Prototype
```c
void aws_http2_connection_get_local_settings( const struct aws_http_connection *http2_connection, struct aws_http2_setting out_settings[AWS_HTTP2_SETTINGS_COUNT]);
```
"""
function aws_http2_connection_get_local_settings(http2_connection, out_settings)
    ccall((:aws_http2_connection_get_local_settings, libaws_c_http), Cvoid, (Ptr{aws_http_connection}, Ptr{aws_http2_setting}), http2_connection, out_settings)
end

"""
    aws_http2_connection_get_remote_settings(http2_connection, out_settings)

Get the settings received from remote peer, which we are using to restricts the message to send.

# Arguments
* `http2_connection`: HTTP/2 connection.
* `out_settings`: fixed size array of [`aws_http2_setting`](@ref) gets set to the remote settings
### Prototype
```c
void aws_http2_connection_get_remote_settings( const struct aws_http_connection *http2_connection, struct aws_http2_setting out_settings[AWS_HTTP2_SETTINGS_COUNT]);
```
"""
function aws_http2_connection_get_remote_settings(http2_connection, out_settings)
    ccall((:aws_http2_connection_get_remote_settings, libaws_c_http), Cvoid, (Ptr{aws_http_connection}, Ptr{aws_http2_setting}), http2_connection, out_settings)
end

"""
    aws_http2_connection_send_goaway(http2_connection, http2_error, allow_more_streams, optional_debug_data)

Send a custom GOAWAY frame (HTTP/2 only).

Note that the connection automatically attempts to send a GOAWAY during shutdown (unless a GOAWAY with a valid Last-Stream-ID has already been sent).

This call can be used to gracefully warn the peer of an impending shutdown (http2\\_error=0, allow\\_more\\_streams=true), or to customize the final GOAWAY frame that is sent by this connection.

The other end may not receive the goaway, if the connection already closed.

# Arguments
* `http2_connection`: HTTP/2 connection.
* `http2_error`: The HTTP/2 error code (RFC-7540 section 7) to send. `enum [`aws_http2_error_code`](@ref)` lists official codes.
* `allow_more_streams`: If true, new peer-initiated streams will continue to be acknowledged and the GOAWAY's Last-Stream-ID will be set to a max value. If false, new peer-initiated streams will be ignored and the GOAWAY's Last-Stream-ID will be set to the latest acknowledged stream.
* `optional_debug_data`: Optional debug data to send. Size must not exceed 16KB.
### Prototype
```c
void aws_http2_connection_send_goaway( struct aws_http_connection *http2_connection, uint32_t http2_error, bool allow_more_streams, const struct aws_byte_cursor *optional_debug_data);
```
"""
function aws_http2_connection_send_goaway(http2_connection, http2_error, allow_more_streams, optional_debug_data)
    ccall((:aws_http2_connection_send_goaway, libaws_c_http), Cvoid, (Ptr{aws_http_connection}, UInt32, Bool, Ptr{aws_byte_cursor}), http2_connection, http2_error, allow_more_streams, optional_debug_data)
end

"""
    aws_http2_connection_get_sent_goaway(http2_connection, out_http2_error, out_last_stream_id)

Get data about the latest GOAWAY frame sent to peer (HTTP/2 only). If no GOAWAY has been sent, AWS\\_ERROR\\_HTTP\\_DATA\\_NOT\\_AVAILABLE will be raised. Note that GOAWAY frames are typically sent automatically by the connection during shutdown.

# Arguments
* `http2_connection`: HTTP/2 connection.
* `out_http2_error`: Gets set to HTTP/2 error code sent in most recent GOAWAY.
* `out_last_stream_id`: Gets set to Last-Stream-ID sent in most recent GOAWAY.
### Prototype
```c
int aws_http2_connection_get_sent_goaway( struct aws_http_connection *http2_connection, uint32_t *out_http2_error, uint32_t *out_last_stream_id);
```
"""
function aws_http2_connection_get_sent_goaway(http2_connection, out_http2_error, out_last_stream_id)
    ccall((:aws_http2_connection_get_sent_goaway, libaws_c_http), Cint, (Ptr{aws_http_connection}, Ptr{UInt32}, Ptr{UInt32}), http2_connection, out_http2_error, out_last_stream_id)
end

"""
    aws_http2_connection_get_received_goaway(http2_connection, out_http2_error, out_last_stream_id)

Get data about the latest GOAWAY frame received from peer (HTTP/2 only). If no GOAWAY has been received, or the GOAWAY payload is still in transmitting, AWS\\_ERROR\\_HTTP\\_DATA\\_NOT\\_AVAILABLE will be raised.

# Arguments
* `http2_connection`: HTTP/2 connection.
* `out_http2_error`: Gets set to HTTP/2 error code received in most recent GOAWAY.
* `out_last_stream_id`: Gets set to Last-Stream-ID received in most recent GOAWAY.
### Prototype
```c
int aws_http2_connection_get_received_goaway( struct aws_http_connection *http2_connection, uint32_t *out_http2_error, uint32_t *out_last_stream_id);
```
"""
function aws_http2_connection_get_received_goaway(http2_connection, out_http2_error, out_last_stream_id)
    ccall((:aws_http2_connection_get_received_goaway, libaws_c_http), Cint, (Ptr{aws_http_connection}, Ptr{UInt32}, Ptr{UInt32}), http2_connection, out_http2_error, out_last_stream_id)
end

"""
    aws_http2_connection_update_window(http2_connection, increment_size)

Increment the connection's flow-control window to keep data flowing (HTTP/2 only).

If the connection was created with `conn_manual_window_management` set true, the flow-control window of the connection will shrink as body data is received for all the streams created on it. (headers, padding, and other metadata do not affect the window). The initial connection flow-control window is 65,535. Once the connection's flow-control window reaches to 0, all the streams on the connection stop receiving any further data.

If `conn_manual_window_management` is false, this call will have no effect. The connection maintains its flow-control windows such that no back-pressure is applied and data arrives as fast as possible.

If you are not connected, this call will have no effect.

Crashes when the connection is not http2 connection. The limit of the Maximum Size is 2**31 - 1. And client will make sure the WINDOW\\_UPDATE frame to be valid.

The client control exactly when the WINDOW\\_UPDATE frame sent. Check `conn_window_size_threshold_to_send_update` for details.

# Arguments
* `http2_connection`: HTTP/2 connection.
* `increment_size`: The size to increment for the connection's flow control window
### Prototype
```c
void aws_http2_connection_update_window(struct aws_http_connection *http2_connection, uint32_t increment_size);
```
"""
function aws_http2_connection_update_window(http2_connection, increment_size)
    ccall((:aws_http2_connection_update_window, libaws_c_http), Cvoid, (Ptr{aws_http_connection}, UInt32), http2_connection, increment_size)
end

"""
Documentation not found.
"""
mutable struct aws_http_connection_manager end

# typedef void ( aws_http_connection_manager_on_connection_setup_fn ) ( struct aws_http_connection * connection , int error_code , void * user_data )
"""
Documentation not found.
"""
const aws_http_connection_manager_on_connection_setup_fn = Cvoid

# typedef void ( aws_http_connection_manager_shutdown_complete_fn ) ( void * user_data )
"""
Documentation not found.
"""
const aws_http_connection_manager_shutdown_complete_fn = Cvoid

"""
    aws_http_manager_metrics

Metrics for logging and debugging purpose.
"""
struct aws_http_manager_metrics
    available_concurrency::Csize_t
    pending_concurrency_acquires::Csize_t
    leased_concurrency::Csize_t
end

"""
    aws_http_connection_manager_options

Documentation not found.
"""
struct aws_http_connection_manager_options
    bootstrap::Ptr{aws_client_bootstrap}
    initial_window_size::Csize_t
    socket_options::Ptr{aws_socket_options}
    response_first_byte_timeout_ms::UInt64
    tls_connection_options::Ptr{aws_tls_connection_options}
    http2_prior_knowledge::Bool
    monitoring_options::Ptr{aws_http_connection_monitoring_options}
    host::aws_byte_cursor
    port::UInt32
    initial_settings_array::Ptr{aws_http2_setting}
    num_initial_settings::Csize_t
    max_closed_streams::Csize_t
    http2_conn_manual_window_management::Bool
    proxy_options::Ptr{aws_http_proxy_options}
    proxy_ev_settings::Ptr{proxy_env_var_settings}
    max_connections::Csize_t
    shutdown_complete_user_data::Ptr{Cvoid}
    shutdown_complete_callback::Ptr{aws_http_connection_manager_shutdown_complete_fn}
    enable_read_back_pressure::Bool
    max_connection_idle_in_milliseconds::UInt64
    connection_acquisition_timeout_ms::UInt64
    max_pending_connection_acquisitions::UInt64
    network_interface_names_array::Ptr{aws_byte_cursor}
    num_network_interface_names::Csize_t
end

"""
    aws_http_connection_manager_acquire(manager)

Documentation not found.
### Prototype
```c
void aws_http_connection_manager_acquire(struct aws_http_connection_manager *manager);
```
"""
function aws_http_connection_manager_acquire(manager)
    ccall((:aws_http_connection_manager_acquire, libaws_c_http), Cvoid, (Ptr{aws_http_connection_manager},), manager)
end

"""
    aws_http_connection_manager_release(manager)

Documentation not found.
### Prototype
```c
void aws_http_connection_manager_release(struct aws_http_connection_manager *manager);
```
"""
function aws_http_connection_manager_release(manager)
    ccall((:aws_http_connection_manager_release, libaws_c_http), Cvoid, (Ptr{aws_http_connection_manager},), manager)
end

"""
    aws_http_connection_manager_new(allocator, options)

Documentation not found.
### Prototype
```c
struct aws_http_connection_manager *aws_http_connection_manager_new( struct aws_allocator *allocator, const struct aws_http_connection_manager_options *options);
```
"""
function aws_http_connection_manager_new(allocator, options)
    ccall((:aws_http_connection_manager_new, libaws_c_http), Ptr{aws_http_connection_manager}, (Ptr{aws_allocator}, Ptr{aws_http_connection_manager_options}), allocator, options)
end

"""
    aws_http_connection_manager_acquire_connection(manager, callback, user_data)

Documentation not found.
### Prototype
```c
void aws_http_connection_manager_acquire_connection( struct aws_http_connection_manager *manager, aws_http_connection_manager_on_connection_setup_fn *callback, void *user_data);
```
"""
function aws_http_connection_manager_acquire_connection(manager, callback, user_data)
    ccall((:aws_http_connection_manager_acquire_connection, libaws_c_http), Cvoid, (Ptr{aws_http_connection_manager}, Ptr{aws_http_connection_manager_on_connection_setup_fn}, Ptr{Cvoid}), manager, callback, user_data)
end

"""
    aws_http_connection_manager_release_connection(manager, connection)

Documentation not found.
### Prototype
```c
int aws_http_connection_manager_release_connection( struct aws_http_connection_manager *manager, struct aws_http_connection *connection);
```
"""
function aws_http_connection_manager_release_connection(manager, connection)
    ccall((:aws_http_connection_manager_release_connection, libaws_c_http), Cint, (Ptr{aws_http_connection_manager}, Ptr{aws_http_connection}), manager, connection)
end

"""
    aws_http_connection_manager_fetch_metrics(manager, out_metrics)

Fetch the current manager metrics from connection manager.

### Prototype
```c
void aws_http_connection_manager_fetch_metrics( const struct aws_http_connection_manager *manager, struct aws_http_manager_metrics *out_metrics);
```
"""
function aws_http_connection_manager_fetch_metrics(manager, out_metrics)
    ccall((:aws_http_connection_manager_fetch_metrics, libaws_c_http), Cvoid, (Ptr{aws_http_connection_manager}, Ptr{aws_http_manager_metrics}), manager, out_metrics)
end

"""
    aws_http_errors

Documentation not found.
"""
@cenum aws_http_errors::UInt32 begin
    AWS_ERROR_HTTP_UNKNOWN = 2048
    AWS_ERROR_HTTP_HEADER_NOT_FOUND = 2049
    AWS_ERROR_HTTP_INVALID_HEADER_FIELD = 2050
    AWS_ERROR_HTTP_INVALID_HEADER_NAME = 2051
    AWS_ERROR_HTTP_INVALID_HEADER_VALUE = 2052
    AWS_ERROR_HTTP_INVALID_METHOD = 2053
    AWS_ERROR_HTTP_INVALID_PATH = 2054
    AWS_ERROR_HTTP_INVALID_STATUS_CODE = 2055
    AWS_ERROR_HTTP_MISSING_BODY_STREAM = 2056
    AWS_ERROR_HTTP_INVALID_BODY_STREAM = 2057
    AWS_ERROR_HTTP_CONNECTION_CLOSED = 2058
    AWS_ERROR_HTTP_SWITCHED_PROTOCOLS = 2059
    AWS_ERROR_HTTP_UNSUPPORTED_PROTOCOL = 2060
    AWS_ERROR_HTTP_REACTION_REQUIRED = 2061
    AWS_ERROR_HTTP_DATA_NOT_AVAILABLE = 2062
    AWS_ERROR_HTTP_OUTGOING_STREAM_LENGTH_INCORRECT = 2063
    AWS_ERROR_HTTP_CALLBACK_FAILURE = 2064
    AWS_ERROR_HTTP_WEBSOCKET_UPGRADE_FAILURE = 2065
    AWS_ERROR_HTTP_WEBSOCKET_CLOSE_FRAME_SENT = 2066
    AWS_ERROR_HTTP_WEBSOCKET_IS_MIDCHANNEL_HANDLER = 2067
    AWS_ERROR_HTTP_CONNECTION_MANAGER_INVALID_STATE_FOR_ACQUIRE = 2068
    AWS_ERROR_HTTP_CONNECTION_MANAGER_VENDED_CONNECTION_UNDERFLOW = 2069
    AWS_ERROR_HTTP_SERVER_CLOSED = 2070
    AWS_ERROR_HTTP_PROXY_CONNECT_FAILED = 2071
    AWS_ERROR_HTTP_CONNECTION_MANAGER_SHUTTING_DOWN = 2072
    AWS_ERROR_HTTP_CHANNEL_THROUGHPUT_FAILURE = 2073
    AWS_ERROR_HTTP_PROTOCOL_ERROR = 2074
    AWS_ERROR_HTTP_STREAM_IDS_EXHAUSTED = 2075
    AWS_ERROR_HTTP_GOAWAY_RECEIVED = 2076
    AWS_ERROR_HTTP_RST_STREAM_RECEIVED = 2077
    AWS_ERROR_HTTP_RST_STREAM_SENT = 2078
    AWS_ERROR_HTTP_STREAM_NOT_ACTIVATED = 2079
    AWS_ERROR_HTTP_STREAM_HAS_COMPLETED = 2080
    AWS_ERROR_HTTP_PROXY_STRATEGY_NTLM_CHALLENGE_TOKEN_MISSING = 2081
    AWS_ERROR_HTTP_PROXY_STRATEGY_TOKEN_RETRIEVAL_FAILURE = 2082
    AWS_ERROR_HTTP_PROXY_CONNECT_FAILED_RETRYABLE = 2083
    AWS_ERROR_HTTP_PROTOCOL_SWITCH_FAILURE = 2084
    AWS_ERROR_HTTP_MAX_CONCURRENT_STREAMS_EXCEEDED = 2085
    AWS_ERROR_HTTP_STREAM_MANAGER_SHUTTING_DOWN = 2086
    AWS_ERROR_HTTP_STREAM_MANAGER_CONNECTION_ACQUIRE_FAILURE = 2087
    AWS_ERROR_HTTP_STREAM_MANAGER_UNEXPECTED_HTTP_VERSION = 2088
    AWS_ERROR_HTTP_WEBSOCKET_PROTOCOL_ERROR = 2089
    AWS_ERROR_HTTP_MANUAL_WRITE_NOT_ENABLED = 2090
    AWS_ERROR_HTTP_MANUAL_WRITE_HAS_COMPLETED = 2091
    AWS_ERROR_HTTP_RESPONSE_FIRST_BYTE_TIMEOUT = 2092
    AWS_ERROR_HTTP_CONNECTION_MANAGER_ACQUISITION_TIMEOUT = 2093
    AWS_ERROR_HTTP_CONNECTION_MANAGER_MAX_PENDING_ACQUISITIONS_EXCEEDED = 2094
    AWS_ERROR_HTTP_END_RANGE = 3071
end

"""
    aws_http2_error_code

Documentation not found.
"""
@cenum aws_http2_error_code::UInt32 begin
    AWS_HTTP2_ERR_NO_ERROR = 0
    AWS_HTTP2_ERR_PROTOCOL_ERROR = 1
    AWS_HTTP2_ERR_INTERNAL_ERROR = 2
    AWS_HTTP2_ERR_FLOW_CONTROL_ERROR = 3
    AWS_HTTP2_ERR_SETTINGS_TIMEOUT = 4
    AWS_HTTP2_ERR_STREAM_CLOSED = 5
    AWS_HTTP2_ERR_FRAME_SIZE_ERROR = 6
    AWS_HTTP2_ERR_REFUSED_STREAM = 7
    AWS_HTTP2_ERR_CANCEL = 8
    AWS_HTTP2_ERR_COMPRESSION_ERROR = 9
    AWS_HTTP2_ERR_CONNECT_ERROR = 10
    AWS_HTTP2_ERR_ENHANCE_YOUR_CALM = 11
    AWS_HTTP2_ERR_INADEQUATE_SECURITY = 12
    AWS_HTTP2_ERR_HTTP_1_1_REQUIRED = 13
    AWS_HTTP2_ERR_COUNT = 14
end

"""
    aws_http_log_subject

Documentation not found.
"""
@cenum aws_http_log_subject::UInt32 begin
    AWS_LS_HTTP_GENERAL = 2048
    AWS_LS_HTTP_CONNECTION = 2049
    AWS_LS_HTTP_ENCODER = 2050
    AWS_LS_HTTP_DECODER = 2051
    AWS_LS_HTTP_SERVER = 2052
    AWS_LS_HTTP_STREAM = 2053
    AWS_LS_HTTP_CONNECTION_MANAGER = 2054
    AWS_LS_HTTP_STREAM_MANAGER = 2055
    AWS_LS_HTTP_WEBSOCKET = 2056
    AWS_LS_HTTP_WEBSOCKET_SETUP = 2057
    AWS_LS_HTTP_PROXY_NEGOTIATION = 2058
end

"""
    aws_http_library_init(alloc)

Initializes internal datastructures used by aws-c-http. Must be called before using any functionality in aws-c-http.

### Prototype
```c
void aws_http_library_init(struct aws_allocator *alloc);
```
"""
function aws_http_library_init(alloc)
    ccall((:aws_http_library_init, libaws_c_http), Cvoid, (Ptr{aws_allocator},), alloc)
end

"""
    aws_http_library_clean_up()

Clean up internal datastructures used by aws-c-http. Must not be called until application is done using functionality in aws-c-http.

### Prototype
```c
void aws_http_library_clean_up(void);
```
"""
function aws_http_library_clean_up()
    ccall((:aws_http_library_clean_up, libaws_c_http), Cvoid, ())
end

"""
    aws_http_status_text(status_code)

Returns the description of common status codes. Ex: 404 -> "Not Found" An empty string is returned if the status code is not recognized.

### Prototype
```c
const char *aws_http_status_text(int status_code);
```
"""
function aws_http_status_text(status_code)
    ccall((:aws_http_status_text, libaws_c_http), Ptr{Cchar}, (Cint,), status_code)
end

"""
Documentation not found.
"""
mutable struct aws_http2_stream_manager end

"""
Documentation not found.
"""
mutable struct aws_http_stream end

# typedef void ( aws_http2_stream_manager_on_stream_acquired_fn ) ( struct aws_http_stream * stream , int error_code , void * user_data )
"""
Always invoked asynchronously when the stream was created, successfully or not. When stream is NULL, error code will be set to indicate what happened. If there is a stream returned, you own the stream completely. Invoked on the same thread as other callback of the stream, which will be the thread of the connection, ideally. If there is no connection made, the callback will be invoked from a sperate thread.
"""
const aws_http2_stream_manager_on_stream_acquired_fn = Cvoid

# typedef void ( aws_http2_stream_manager_shutdown_complete_fn ) ( void * user_data )
"""
Invoked asynchronously when the stream manager has been shutdown completely. Never invoked when [`aws_http2_stream_manager_new`](@ref) failed.
"""
const aws_http2_stream_manager_shutdown_complete_fn = Cvoid

"""
    aws_http2_stream_manager_options

HTTP/2 stream manager configuration struct.

Contains all of the configuration needed to create an http2 connection as well as connection manager under the hood.
"""
struct aws_http2_stream_manager_options
    bootstrap::Ptr{aws_client_bootstrap}
    socket_options::Ptr{aws_socket_options}
    tls_connection_options::Ptr{aws_tls_connection_options}
    http2_prior_knowledge::Bool
    host::aws_byte_cursor
    port::UInt32
    initial_settings_array::Ptr{aws_http2_setting}
    num_initial_settings::Csize_t
    max_closed_streams::Csize_t
    conn_manual_window_management::Bool
    enable_read_back_pressure::Bool
    initial_window_size::Csize_t
    monitoring_options::Ptr{aws_http_connection_monitoring_options}
    proxy_options::Ptr{aws_http_proxy_options}
    proxy_ev_settings::Ptr{proxy_env_var_settings}
    shutdown_complete_user_data::Ptr{Cvoid}
    shutdown_complete_callback::Ptr{aws_http2_stream_manager_shutdown_complete_fn}
    close_connection_on_server_error::Bool
    connection_ping_period_ms::Csize_t
    connection_ping_timeout_ms::Csize_t
    ideal_concurrent_streams_per_connection::Csize_t
    max_concurrent_streams_per_connection::Csize_t
    max_connections::Csize_t
end

"""
Documentation not found.
"""
mutable struct aws_http_message end

# typedef int ( aws_http_on_incoming_headers_fn ) ( struct aws_http_stream * stream , enum aws_http_header_block header_block , const struct aws_http_header * header_array , size_t num_headers , void * user_data )
"""
Invoked repeatedly times as headers are received. At this point, [`aws_http_stream_get_incoming_response_status`](@ref)() can be called for the client. And [`aws_http_stream_get_incoming_request_method`](@ref)() and [`aws_http_stream_get_incoming_request_uri`](@ref)() can be called for the server. This is always invoked on the HTTP connection's event-loop thread.

Return AWS\\_OP\\_SUCCESS to continue processing the stream. Return aws\\_raise\\_error(E) to indicate failure and cancel the stream. The error you raise will be reflected in the error\\_code passed to the on\\_complete callback.
"""
const aws_http_on_incoming_headers_fn = Cvoid

# typedef int ( aws_http_on_incoming_header_block_done_fn ) ( struct aws_http_stream * stream , enum aws_http_header_block header_block , void * user_data )
"""
Invoked when the incoming header block of this type(informational/main/trailing) has been completely read. This is always invoked on the HTTP connection's event-loop thread.

Return AWS\\_OP\\_SUCCESS to continue processing the stream. Return aws\\_raise\\_error(E) to indicate failure and cancel the stream. The error you raise will be reflected in the error\\_code passed to the on\\_complete callback.
"""
const aws_http_on_incoming_header_block_done_fn = Cvoid

# typedef int ( aws_http_on_incoming_body_fn ) ( struct aws_http_stream * stream , const struct aws_byte_cursor * data , void * user_data )
"""
Called repeatedly as body data is received. The data must be copied immediately if you wish to preserve it. This is always invoked on the HTTP connection's event-loop thread.

Note that, if the connection is using manual\\_window\\_management then the window size has shrunk by the amount of body data received. If the window size reaches 0 no further data will be received. Increment the window size with [`aws_http_stream_update_window`](@ref)().

Return AWS\\_OP\\_SUCCESS to continue processing the stream. Return aws\\_raise\\_error(E) to indicate failure and cancel the stream. The error you raise will be reflected in the error\\_code passed to the on\\_complete callback.
"""
const aws_http_on_incoming_body_fn = Cvoid

# typedef void ( aws_http_on_stream_metrics_fn ) ( struct aws_http_stream * stream , const struct aws_http_stream_metrics * metrics , void * user_data )
"""
Invoked right before request/response stream is complete to report the tracing metrics for [`aws_http_stream`](@ref). This may be invoked synchronously when [`aws_http_stream_release`](@ref)() is called. This is invoked even if the stream is never activated. See [`aws_http_stream_metrics`](@ref) for details.
"""
const aws_http_on_stream_metrics_fn = Cvoid

# typedef void ( aws_http_on_stream_complete_fn ) ( struct aws_http_stream * stream , int error_code , void * user_data )
"""
Invoked when a request/response stream is complete, whether successful or unsuccessful This is always invoked on the HTTP connection's event-loop thread. This will not be invoked if the stream is never activated.
"""
const aws_http_on_stream_complete_fn = Cvoid

# typedef void ( aws_http_on_stream_destroy_fn ) ( void * user_data )
"""
Invoked when request/response stream destroy completely. This can be invoked within the same thead who release the refcount on http stream. This is invoked even if the stream is never activated.
"""
const aws_http_on_stream_destroy_fn = Cvoid

"""
    aws_http_make_request_options

Options for creating a stream which sends a request from the client and receives a response from the server.
"""
struct aws_http_make_request_options
    self_size::Csize_t
    request::Ptr{aws_http_message}
    user_data::Ptr{Cvoid}
    on_response_headers::Ptr{aws_http_on_incoming_headers_fn}
    on_response_header_block_done::Ptr{aws_http_on_incoming_header_block_done_fn}
    on_response_body::Ptr{aws_http_on_incoming_body_fn}
    on_metrics::Ptr{aws_http_on_stream_metrics_fn}
    on_complete::Ptr{aws_http_on_stream_complete_fn}
    on_destroy::Ptr{aws_http_on_stream_destroy_fn}
    http2_use_manual_data_writes::Bool
    response_first_byte_timeout_ms::UInt64
end

"""
    aws_http2_stream_manager_acquire_stream_options

Documentation not found.
"""
struct aws_http2_stream_manager_acquire_stream_options
    callback::Ptr{aws_http2_stream_manager_on_stream_acquired_fn}
    user_data::Ptr{Cvoid}
    options::Ptr{aws_http_make_request_options}
end

"""
    aws_http2_stream_manager_acquire(manager)

Acquire a refcount from the stream manager, stream manager will start to destroy after the refcount drops to zero. NULL is acceptable. Initial refcount after new is 1.

# Arguments
* `manager`:
# Returns
The same pointer acquiring.
### Prototype
```c
struct aws_http2_stream_manager *aws_http2_stream_manager_acquire(struct aws_http2_stream_manager *manager);
```
"""
function aws_http2_stream_manager_acquire(manager)
    ccall((:aws_http2_stream_manager_acquire, libaws_c_http), Ptr{aws_http2_stream_manager}, (Ptr{aws_http2_stream_manager},), manager)
end

"""
    aws_http2_stream_manager_release(manager)

Release a refcount from the stream manager, stream manager will start to destroy after the refcount drops to zero. NULL is acceptable. Initial refcount after new is 1.

# Arguments
* `manager`:
# Returns
NULL
### Prototype
```c
struct aws_http2_stream_manager *aws_http2_stream_manager_release(struct aws_http2_stream_manager *manager);
```
"""
function aws_http2_stream_manager_release(manager)
    ccall((:aws_http2_stream_manager_release, libaws_c_http), Ptr{aws_http2_stream_manager}, (Ptr{aws_http2_stream_manager},), manager)
end

"""
    aws_http2_stream_manager_new(allocator, options)

Documentation not found.
### Prototype
```c
struct aws_http2_stream_manager *aws_http2_stream_manager_new( struct aws_allocator *allocator, const struct aws_http2_stream_manager_options *options);
```
"""
function aws_http2_stream_manager_new(allocator, options)
    ccall((:aws_http2_stream_manager_new, libaws_c_http), Ptr{aws_http2_stream_manager}, (Ptr{aws_allocator}, Ptr{aws_http2_stream_manager_options}), allocator, options)
end

"""
    aws_http2_stream_manager_acquire_stream(http2_stream_manager, acquire_stream_option)

Acquire a stream from stream manager asynchronously.

# Arguments
* `http2_stream_manager`:
* `acquire_stream_option`: see [`aws_http2_stream_manager_acquire_stream_options`](@ref)
### Prototype
```c
void aws_http2_stream_manager_acquire_stream( struct aws_http2_stream_manager *http2_stream_manager, const struct aws_http2_stream_manager_acquire_stream_options *acquire_stream_option);
```
"""
function aws_http2_stream_manager_acquire_stream(http2_stream_manager, acquire_stream_option)
    ccall((:aws_http2_stream_manager_acquire_stream, libaws_c_http), Cvoid, (Ptr{aws_http2_stream_manager}, Ptr{aws_http2_stream_manager_acquire_stream_options}), http2_stream_manager, acquire_stream_option)
end

"""
    aws_http2_stream_manager_fetch_metrics(http2_stream_manager, out_metrics)

Fetch the current metrics from stream manager.

# Arguments
* `http2_stream_manager`:
* `out_metrics`: The metrics to be fetched
### Prototype
```c
void aws_http2_stream_manager_fetch_metrics( const struct aws_http2_stream_manager *http2_stream_manager, struct aws_http_manager_metrics *out_metrics);
```
"""
function aws_http2_stream_manager_fetch_metrics(http2_stream_manager, out_metrics)
    ccall((:aws_http2_stream_manager_fetch_metrics, libaws_c_http), Cvoid, (Ptr{aws_http2_stream_manager}, Ptr{aws_http_manager_metrics}), http2_stream_manager, out_metrics)
end

"""
Documentation not found.
"""
mutable struct aws_http_proxy_config end

# typedef struct aws_string * ( aws_http_proxy_negotiation_get_token_sync_fn ) ( void * user_data , int * out_error_code )
"""
Synchronous (for now) callback function to fetch a token used in modifying CONNECT requests
"""
const aws_http_proxy_negotiation_get_token_sync_fn = Cvoid

# typedef struct aws_string * ( aws_http_proxy_negotiation_get_challenge_token_sync_fn ) ( void * user_data , const struct aws_byte_cursor * challenge_context , int * out_error_code )
"""
Synchronous (for now) callback function to fetch a token used in modifying CONNECT request. Includes a (byte string) context intended to be used as part of a challenge-response flow.
"""
const aws_http_proxy_negotiation_get_challenge_token_sync_fn = Cvoid

# typedef void ( aws_http_proxy_negotiation_terminate_fn ) ( struct aws_http_message * message , int error_code , void * internal_proxy_user_data )
"""
Proxy negotiation logic must call this function to indicate an unsuccessful outcome
"""
const aws_http_proxy_negotiation_terminate_fn = Cvoid

# typedef void ( aws_http_proxy_negotiation_http_request_forward_fn ) ( struct aws_http_message * message , void * internal_proxy_user_data )
"""
Proxy negotiation logic must call this function to forward the potentially-mutated request back to the proxy connection logic.
"""
const aws_http_proxy_negotiation_http_request_forward_fn = Cvoid

# typedef void ( aws_http_proxy_negotiation_http_request_transform_async_fn ) ( struct aws_http_proxy_negotiator * proxy_negotiator , struct aws_http_message * message , aws_http_proxy_negotiation_terminate_fn * negotiation_termination_callback , aws_http_proxy_negotiation_http_request_forward_fn * negotiation_http_request_forward_callback , void * internal_proxy_user_data )
"""
User-supplied transform callback which implements the proxy request flow and ultimately, across all execution pathways, invokes either the terminate function or the forward function appropriately.

For tunneling proxy connections, this request flow transform only applies to the CONNECT stage of proxy connection establishment.

For forwarding proxy connections, this request flow transform applies to every single http request that goes out on the connection.

Forwarding proxy connections cannot yet support a truly async request transform without major surgery on http stream creation, so for now, we split into an async version (for tunneling proxies) and a separate synchronous version for forwarding proxies. Also forwarding proxies are a kind of legacy dead-end in some sense.
"""
const aws_http_proxy_negotiation_http_request_transform_async_fn = Cvoid

# typedef int ( aws_http_proxy_negotiation_http_request_transform_fn ) ( struct aws_http_proxy_negotiator * proxy_negotiator , struct aws_http_message * message )
"""
Documentation not found.
"""
const aws_http_proxy_negotiation_http_request_transform_fn = Cvoid

# typedef int ( aws_http_proxy_negotiation_connect_on_incoming_headers_fn ) ( struct aws_http_proxy_negotiator * proxy_negotiator , enum aws_http_header_block header_block , const struct aws_http_header * header_array , size_t num_headers )
"""
Tunneling proxy connections only. A callback that lets the negotiator examine the headers in the response to the most recent CONNECT request as they arrive.
"""
const aws_http_proxy_negotiation_connect_on_incoming_headers_fn = Cvoid

# typedef int ( aws_http_proxy_negotiator_connect_status_fn ) ( struct aws_http_proxy_negotiator * proxy_negotiator , enum aws_http_status_code status_code )
"""
Tunneling proxy connections only. A callback that lets the negotiator examine the status code of the response to the most recent CONNECT request.
"""
const aws_http_proxy_negotiator_connect_status_fn = Cvoid

# typedef int ( aws_http_proxy_negotiator_connect_on_incoming_body_fn ) ( struct aws_http_proxy_negotiator * proxy_negotiator , const struct aws_byte_cursor * data )
"""
Tunneling proxy connections only. A callback that lets the negotiator examine the body of the response to the most recent CONNECT request.
"""
const aws_http_proxy_negotiator_connect_on_incoming_body_fn = Cvoid

"""
    aws_http_proxy_negotiation_retry_directive

Documentation not found.
"""
@cenum aws_http_proxy_negotiation_retry_directive::UInt32 begin
    AWS_HPNRD_STOP = 0
    AWS_HPNRD_NEW_CONNECTION = 1
    AWS_HPNRD_CURRENT_CONNECTION = 2
end

# typedef enum aws_http_proxy_negotiation_retry_directive ( aws_http_proxy_negotiator_get_retry_directive_fn ) ( struct aws_http_proxy_negotiator * proxy_negotiator )
"""
Documentation not found.
"""
const aws_http_proxy_negotiator_get_retry_directive_fn = Cvoid

"""
    aws_http_proxy_negotiator_forwarding_vtable

Vtable for forwarding-based proxy negotiators
"""
struct aws_http_proxy_negotiator_forwarding_vtable
    forward_request_transform::Ptr{aws_http_proxy_negotiation_http_request_transform_fn}
end

"""
    aws_http_proxy_negotiator_tunnelling_vtable

Vtable for tunneling-based proxy negotiators
"""
struct aws_http_proxy_negotiator_tunnelling_vtable
    connect_request_transform::Ptr{aws_http_proxy_negotiation_http_request_transform_async_fn}
    on_incoming_headers_callback::Ptr{aws_http_proxy_negotiation_connect_on_incoming_headers_fn}
    on_status_callback::Ptr{aws_http_proxy_negotiator_connect_status_fn}
    on_incoming_body_callback::Ptr{aws_http_proxy_negotiator_connect_on_incoming_body_fn}
    get_retry_directive::Ptr{aws_http_proxy_negotiator_get_retry_directive_fn}
end

"""
    union (unnamed at /home/runner/.julia/artifacts/d223865603d78d58ded272fb3a0bd9859655857b/include/aws/http/proxy.h:304:5)

Documentation not found.
"""
struct var"union (unnamed at /home/runner/.julia/artifacts/d223865603d78d58ded272fb3a0bd9859655857b/include/aws/http/proxy.h:304:5)"
    data::NTuple{4, UInt8}
end

function Base.getproperty(x::Ptr{var"union (unnamed at /home/runner/.julia/artifacts/d223865603d78d58ded272fb3a0bd9859655857b/include/aws/http/proxy.h:304:5)"}, f::Symbol)
    f === :forwarding_vtable && return Ptr{Ptr{aws_http_proxy_negotiator_forwarding_vtable}}(x + 0)
    f === :tunnelling_vtable && return Ptr{Ptr{aws_http_proxy_negotiator_tunnelling_vtable}}(x + 0)
    return getfield(x, f)
end

function Base.getproperty(x::var"union (unnamed at /home/runner/.julia/artifacts/d223865603d78d58ded272fb3a0bd9859655857b/include/aws/http/proxy.h:304:5)", f::Symbol)
    r = Ref{var"union (unnamed at /home/runner/.julia/artifacts/d223865603d78d58ded272fb3a0bd9859655857b/include/aws/http/proxy.h:304:5)"}(x)
    ptr = Base.unsafe_convert(Ptr{var"union (unnamed at /home/runner/.julia/artifacts/d223865603d78d58ded272fb3a0bd9859655857b/include/aws/http/proxy.h:304:5)"}, r)
    fptr = getproperty(ptr, f)
    GC.@preserve r unsafe_load(fptr)
end

function Base.setproperty!(x::Ptr{var"union (unnamed at /home/runner/.julia/artifacts/d223865603d78d58ded272fb3a0bd9859655857b/include/aws/http/proxy.h:304:5)"}, f::Symbol, v)
    unsafe_store!(getproperty(x, f), v)
end

"""
    aws_http_proxy_negotiator

Documentation not found.
"""
struct aws_http_proxy_negotiator
    data::NTuple{20, UInt8}
end

function Base.getproperty(x::Ptr{aws_http_proxy_negotiator}, f::Symbol)
    f === :ref_count && return Ptr{aws_ref_count}(x + 0)
    f === :impl && return Ptr{Ptr{Cvoid}}(x + 12)
    f === :strategy_vtable && return Ptr{var"union (unnamed at /home/runner/.julia/artifacts/d223865603d78d58ded272fb3a0bd9859655857b/include/aws/http/proxy.h:304:5)"}(x + 16)
    return getfield(x, f)
end

function Base.getproperty(x::aws_http_proxy_negotiator, f::Symbol)
    r = Ref{aws_http_proxy_negotiator}(x)
    ptr = Base.unsafe_convert(Ptr{aws_http_proxy_negotiator}, r)
    fptr = getproperty(ptr, f)
    GC.@preserve r unsafe_load(fptr)
end

function Base.setproperty!(x::Ptr{aws_http_proxy_negotiator}, f::Symbol, v)
    unsafe_store!(getproperty(x, f), v)
end

"""
    aws_http_proxy_strategy_basic_auth_options

Documentation not found.
"""
struct aws_http_proxy_strategy_basic_auth_options
    proxy_connection_type::aws_http_proxy_connection_type
    user_name::aws_byte_cursor
    password::aws_byte_cursor
end

"""
    aws_http_proxy_strategy_tunneling_kerberos_options

Documentation not found.
"""
struct aws_http_proxy_strategy_tunneling_kerberos_options
    get_token::Ptr{aws_http_proxy_negotiation_get_token_sync_fn}
    get_token_user_data::Ptr{Cvoid}
end

"""
    aws_http_proxy_strategy_tunneling_ntlm_options

Documentation not found.
"""
struct aws_http_proxy_strategy_tunneling_ntlm_options
    get_token::Ptr{aws_http_proxy_negotiation_get_token_sync_fn}
    get_challenge_token::Ptr{aws_http_proxy_negotiation_get_challenge_token_sync_fn}
    get_challenge_token_user_data::Ptr{Cvoid}
end

"""
    aws_http_proxy_strategy_tunneling_adaptive_options

Documentation not found.
"""
struct aws_http_proxy_strategy_tunneling_adaptive_options
    kerberos_options::Ptr{aws_http_proxy_strategy_tunneling_kerberos_options}
    ntlm_options::Ptr{aws_http_proxy_strategy_tunneling_ntlm_options}
end

"""
    aws_http_proxy_strategy_tunneling_sequence_options

Documentation not found.
"""
struct aws_http_proxy_strategy_tunneling_sequence_options
    strategies::Ptr{Ptr{aws_http_proxy_strategy}}
    strategy_count::UInt32
end

"""
    aws_http_proxy_negotiator_acquire(proxy_negotiator)

Take a reference to an http proxy negotiator

# Arguments
* `proxy_negotiator`: negotiator to take a reference to
# Returns
the strategy
### Prototype
```c
struct aws_http_proxy_negotiator *aws_http_proxy_negotiator_acquire(struct aws_http_proxy_negotiator *proxy_negotiator);
```
"""
function aws_http_proxy_negotiator_acquire(proxy_negotiator)
    ccall((:aws_http_proxy_negotiator_acquire, libaws_c_http), Ptr{aws_http_proxy_negotiator}, (Ptr{aws_http_proxy_negotiator},), proxy_negotiator)
end

"""
    aws_http_proxy_negotiator_release(proxy_negotiator)

Release a reference to an http proxy negotiator

# Arguments
* `proxy_negotiator`: negotiator to release a reference to
### Prototype
```c
void aws_http_proxy_negotiator_release(struct aws_http_proxy_negotiator *proxy_negotiator);
```
"""
function aws_http_proxy_negotiator_release(proxy_negotiator)
    ccall((:aws_http_proxy_negotiator_release, libaws_c_http), Cvoid, (Ptr{aws_http_proxy_negotiator},), proxy_negotiator)
end

"""
    aws_http_proxy_strategy_create_negotiator(strategy, allocator)

Creates a new proxy negotiator from a proxy strategy

# Arguments
* `allocator`: memory allocator to use
* `strategy`: strategy to creation a new negotiator for
# Returns
a new proxy negotiator if successful, otherwise NULL
### Prototype
```c
struct aws_http_proxy_negotiator *aws_http_proxy_strategy_create_negotiator( struct aws_http_proxy_strategy *strategy, struct aws_allocator *allocator);
```
"""
function aws_http_proxy_strategy_create_negotiator(strategy, allocator)
    ccall((:aws_http_proxy_strategy_create_negotiator, libaws_c_http), Ptr{aws_http_proxy_negotiator}, (Ptr{aws_http_proxy_strategy}, Ptr{aws_allocator}), strategy, allocator)
end

"""
    aws_http_proxy_strategy_acquire(proxy_strategy)

Take a reference to an http proxy strategy

# Arguments
* `proxy_strategy`: strategy to take a reference to
# Returns
the strategy
### Prototype
```c
struct aws_http_proxy_strategy *aws_http_proxy_strategy_acquire(struct aws_http_proxy_strategy *proxy_strategy);
```
"""
function aws_http_proxy_strategy_acquire(proxy_strategy)
    ccall((:aws_http_proxy_strategy_acquire, libaws_c_http), Ptr{aws_http_proxy_strategy}, (Ptr{aws_http_proxy_strategy},), proxy_strategy)
end

"""
    aws_http_proxy_strategy_release(proxy_strategy)

Release a reference to an http proxy strategy

# Arguments
* `proxy_strategy`: strategy to release a reference to
### Prototype
```c
void aws_http_proxy_strategy_release(struct aws_http_proxy_strategy *proxy_strategy);
```
"""
function aws_http_proxy_strategy_release(proxy_strategy)
    ccall((:aws_http_proxy_strategy_release, libaws_c_http), Cvoid, (Ptr{aws_http_proxy_strategy},), proxy_strategy)
end

"""
    aws_http_proxy_strategy_new_basic_auth(allocator, config)

A constructor for a proxy strategy that performs basic authentication by adding the appropriate header and header value to requests or CONNECT requests.

# Arguments
* `allocator`: memory allocator to use
* `config`: basic authentication configuration info
# Returns
a new proxy strategy if successfully constructed, otherwise NULL
### Prototype
```c
struct aws_http_proxy_strategy *aws_http_proxy_strategy_new_basic_auth( struct aws_allocator *allocator, struct aws_http_proxy_strategy_basic_auth_options *config);
```
"""
function aws_http_proxy_strategy_new_basic_auth(allocator, config)
    ccall((:aws_http_proxy_strategy_new_basic_auth, libaws_c_http), Ptr{aws_http_proxy_strategy}, (Ptr{aws_allocator}, Ptr{aws_http_proxy_strategy_basic_auth_options}), allocator, config)
end

"""
    aws_http_proxy_strategy_new_tunneling_adaptive(allocator, config)

Constructor for an adaptive tunneling proxy strategy. This strategy attempts a vanilla CONNECT and if that fails it may make followup CONNECT attempts using kerberos or ntlm tokens, based on configuration and proxy response properties.

# Arguments
* `allocator`: memory allocator to use
* `config`: configuration options for the strategy
# Returns
a new proxy strategy if successfully constructed, otherwise NULL
### Prototype
```c
struct aws_http_proxy_strategy *aws_http_proxy_strategy_new_tunneling_adaptive( struct aws_allocator *allocator, struct aws_http_proxy_strategy_tunneling_adaptive_options *config);
```
"""
function aws_http_proxy_strategy_new_tunneling_adaptive(allocator, config)
    ccall((:aws_http_proxy_strategy_new_tunneling_adaptive, libaws_c_http), Ptr{aws_http_proxy_strategy}, (Ptr{aws_allocator}, Ptr{aws_http_proxy_strategy_tunneling_adaptive_options}), allocator, config)
end

"""
    aws_http_proxy_config_new_from_connection_options(allocator, options)

Create a persistent proxy configuration from http connection options

# Arguments
* `allocator`: memory allocator to use
* `options`: http connection options to source proxy configuration from
# Returns

### Prototype
```c
struct aws_http_proxy_config *aws_http_proxy_config_new_from_connection_options( struct aws_allocator *allocator, const struct aws_http_client_connection_options *options);
```
"""
function aws_http_proxy_config_new_from_connection_options(allocator, options)
    ccall((:aws_http_proxy_config_new_from_connection_options, libaws_c_http), Ptr{aws_http_proxy_config}, (Ptr{aws_allocator}, Ptr{aws_http_client_connection_options}), allocator, options)
end

"""
    aws_http_proxy_config_new_from_manager_options(allocator, options)

Create a persistent proxy configuration from http connection manager options

# Arguments
* `allocator`: memory allocator to use
* `options`: http connection manager options to source proxy configuration from
# Returns

### Prototype
```c
struct aws_http_proxy_config *aws_http_proxy_config_new_from_manager_options( struct aws_allocator *allocator, const struct aws_http_connection_manager_options *options);
```
"""
function aws_http_proxy_config_new_from_manager_options(allocator, options)
    ccall((:aws_http_proxy_config_new_from_manager_options, libaws_c_http), Ptr{aws_http_proxy_config}, (Ptr{aws_allocator}, Ptr{aws_http_connection_manager_options}), allocator, options)
end

"""
    aws_http_proxy_config_new_tunneling_from_proxy_options(allocator, options)

Create a persistent proxy configuration from non-persistent proxy options. The resulting proxy configuration assumes a tunneling connection type.

# Arguments
* `allocator`: memory allocator to use
* `options`: http proxy options to source proxy configuration from
# Returns

### Prototype
```c
struct aws_http_proxy_config *aws_http_proxy_config_new_tunneling_from_proxy_options( struct aws_allocator *allocator, const struct aws_http_proxy_options *options);
```
"""
function aws_http_proxy_config_new_tunneling_from_proxy_options(allocator, options)
    ccall((:aws_http_proxy_config_new_tunneling_from_proxy_options, libaws_c_http), Ptr{aws_http_proxy_config}, (Ptr{aws_allocator}, Ptr{aws_http_proxy_options}), allocator, options)
end

"""
    aws_http_proxy_config_new_from_proxy_options(allocator, options)

Create a persistent proxy configuration from non-persistent proxy options. Legacy connection type of proxy options will be rejected.

# Arguments
* `allocator`: memory allocator to use
* `options`: http proxy options to source proxy configuration from
# Returns

### Prototype
```c
struct aws_http_proxy_config *aws_http_proxy_config_new_from_proxy_options( struct aws_allocator *allocator, const struct aws_http_proxy_options *options);
```
"""
function aws_http_proxy_config_new_from_proxy_options(allocator, options)
    ccall((:aws_http_proxy_config_new_from_proxy_options, libaws_c_http), Ptr{aws_http_proxy_config}, (Ptr{aws_allocator}, Ptr{aws_http_proxy_options}), allocator, options)
end

"""
    aws_http_proxy_config_new_from_proxy_options_with_tls_info(allocator, proxy_options, is_tls_connection)

Create a persistent proxy configuration from non-persistent proxy options.

# Arguments
* `allocator`: memory allocator to use
* `options`: http proxy options to source proxy configuration from
* `is_tls_connection`: tls connection info of the main connection to determine connection\\_type when the connection\\_type is legacy.
# Returns

### Prototype
```c
struct aws_http_proxy_config *aws_http_proxy_config_new_from_proxy_options_with_tls_info( struct aws_allocator *allocator, const struct aws_http_proxy_options *proxy_options, bool is_tls_connection);
```
"""
function aws_http_proxy_config_new_from_proxy_options_with_tls_info(allocator, proxy_options, is_tls_connection)
    ccall((:aws_http_proxy_config_new_from_proxy_options_with_tls_info, libaws_c_http), Ptr{aws_http_proxy_config}, (Ptr{aws_allocator}, Ptr{aws_http_proxy_options}, Bool), allocator, proxy_options, is_tls_connection)
end

"""
    aws_http_proxy_config_new_clone(allocator, proxy_config)

Clones an existing proxy configuration. A refactor could remove this (do a "move" between the old and new user data in the one spot it's used) but that should wait until we have better test cases for the logic where this gets invoked (ntlm/kerberos chains).

# Arguments
* `allocator`: memory allocator to use
* `proxy_config`: http proxy configuration to clone
# Returns

### Prototype
```c
struct aws_http_proxy_config *aws_http_proxy_config_new_clone( struct aws_allocator *allocator, const struct aws_http_proxy_config *proxy_config);
```
"""
function aws_http_proxy_config_new_clone(allocator, proxy_config)
    ccall((:aws_http_proxy_config_new_clone, libaws_c_http), Ptr{aws_http_proxy_config}, (Ptr{aws_allocator}, Ptr{aws_http_proxy_config}), allocator, proxy_config)
end

"""
    aws_http_proxy_config_destroy(config)

Destroys an http proxy configuration

# Arguments
* `config`: http proxy configuration to destroy
### Prototype
```c
void aws_http_proxy_config_destroy(struct aws_http_proxy_config *config);
```
"""
function aws_http_proxy_config_destroy(config)
    ccall((:aws_http_proxy_config_destroy, libaws_c_http), Cvoid, (Ptr{aws_http_proxy_config},), config)
end

"""
    aws_http_proxy_options_init_from_config(options, config)

Initializes non-persistent http proxy options from a persistent http proxy configuration

# Arguments
* `options`: http proxy options to initialize
* `config`: the http proxy config to use as an initialization source
### Prototype
```c
void aws_http_proxy_options_init_from_config( struct aws_http_proxy_options *options, const struct aws_http_proxy_config *config);
```
"""
function aws_http_proxy_options_init_from_config(options, config)
    ccall((:aws_http_proxy_options_init_from_config, libaws_c_http), Cvoid, (Ptr{aws_http_proxy_options}, Ptr{aws_http_proxy_config}), options, config)
end

"""
    aws_http_proxy_new_socket_channel(channel_options, proxy_options)

Establish an arbitrary protocol connection through an http proxy via tunneling CONNECT. Alpn is not required for this connection process to succeed, but we encourage its use if available.

# Arguments
* `channel_options`: configuration options for the socket level connection
* `proxy_options`: configuration options for the proxy connection
# Returns
AWS\\_OP\\_SUCCESS if the asynchronous channel kickoff succeeded, AWS\\_OP\\_ERR otherwise
### Prototype
```c
int aws_http_proxy_new_socket_channel( struct aws_socket_channel_bootstrap_options *channel_options, const struct aws_http_proxy_options *proxy_options);
```
"""
function aws_http_proxy_new_socket_channel(channel_options, proxy_options)
    ccall((:aws_http_proxy_new_socket_channel, libaws_c_http), Cint, (Ptr{aws_socket_channel_bootstrap_options}, Ptr{aws_http_proxy_options}), channel_options, proxy_options)
end

"""
    aws_http_header_compression

Controls whether a header's strings may be compressed by encoding the index of strings in a cache, rather than encoding the literal string.

This setting has no effect on HTTP/1.x connections. On HTTP/2 connections this controls HPACK behavior. See RFC-7541 Section 7.1 for security considerations.
"""
@cenum aws_http_header_compression::UInt32 begin
    AWS_HTTP_HEADER_COMPRESSION_USE_CACHE = 0
    AWS_HTTP_HEADER_COMPRESSION_NO_CACHE = 1
    AWS_HTTP_HEADER_COMPRESSION_NO_FORWARD_CACHE = 2
end

"""
    aws_http_header

A lightweight HTTP header struct. Note that the underlying strings are not owned by the byte cursors.
"""
struct aws_http_header
    name::aws_byte_cursor
    value::aws_byte_cursor
    compression::aws_http_header_compression
end

"""
A transformable block of HTTP headers. Provides a nice API for getting/setting header names and values.

All strings are copied and stored within this datastructure. The index of a given header may change any time headers are modified. When iterating headers, the following ordering rules apply:

- Headers with the same name will always be in the same order, relative to one another. If "A: one" is added before "A: two", then "A: one" will always precede "A: two".

- Headers with different names could be in any order, relative to one another. If "A: one" is seen before "B: bee" in one iteration, you might see "B: bee" before "A: one" on the next.
"""
mutable struct aws_http_headers end

"""
    aws_http_header_block

Header block type. INFORMATIONAL: Header block for 1xx informational (interim) responses. MAIN: Main header block sent with request or response. TRAILING: Headers sent after the body of a request or response.
"""
@cenum aws_http_header_block::UInt32 begin
    AWS_HTTP_HEADER_BLOCK_MAIN = 0
    AWS_HTTP_HEADER_BLOCK_INFORMATIONAL = 1
    AWS_HTTP_HEADER_BLOCK_TRAILING = 2
end

# typedef void ( aws_http_message_transform_complete_fn ) ( struct aws_http_message * message , int error_code , void * complete_ctx )
"""
Function to invoke when a message transformation completes. This function MUST be invoked or the application will soft-lock. `message` and `complete_ctx` must be the same pointers provided to the [`aws_http_message_transform_fn`](@ref). `error_code` should should be AWS\\_ERROR\\_SUCCESS if transformation was successful, otherwise pass a different AWS\\_ERROR\\_X value.
"""
const aws_http_message_transform_complete_fn = Cvoid

# typedef void ( aws_http_message_transform_fn ) ( struct aws_http_message * message , void * user_data , aws_http_message_transform_complete_fn * complete_fn , void * complete_ctx )
"""
A function that may modify a request or response before it is sent. The transformation may be asynchronous or immediate. The user MUST invoke the `complete_fn` when transformation is complete or the application will soft-lock. When invoking the `complete_fn`, pass along the `message` and `complete_ctx` provided here and an error code. The error code should be AWS\\_ERROR\\_SUCCESS if transformation was successful, otherwise pass a different AWS\\_ERROR\\_X value.
"""
const aws_http_message_transform_fn = Cvoid

# typedef int ( aws_http_on_incoming_request_done_fn ) ( struct aws_http_stream * stream , void * user_data )
"""
Invoked when request has been completely read. This is always invoked on the HTTP connection's event-loop thread.

Return AWS\\_OP\\_SUCCESS to continue processing the stream. Return aws\\_raise\\_error(E) to indicate failure and cancel the stream. The error you raise will be reflected in the error\\_code passed to the on\\_complete callback.
"""
const aws_http_on_incoming_request_done_fn = Cvoid

"""
    aws_http_stream_metrics

Tracing metrics for [`aws_http_stream`](@ref). Data maybe not be available if the data of stream was never sent/received before it completes.
"""
struct aws_http_stream_metrics
    send_start_timestamp_ns::Int64
    send_end_timestamp_ns::Int64
    sending_duration_ns::Int64
    receive_start_timestamp_ns::Int64
    receive_end_timestamp_ns::Int64
    receiving_duration_ns::Int64
    stream_id::UInt32
end

"""
    aws_http_request_handler_options

Documentation not found.
"""
struct aws_http_request_handler_options
    self_size::Csize_t
    server_connection::Ptr{aws_http_connection}
    user_data::Ptr{Cvoid}
    on_request_headers::Ptr{aws_http_on_incoming_headers_fn}
    on_request_header_block_done::Ptr{aws_http_on_incoming_header_block_done_fn}
    on_request_body::Ptr{aws_http_on_incoming_body_fn}
    on_request_done::Ptr{aws_http_on_incoming_request_done_fn}
    on_complete::Ptr{aws_http_on_stream_complete_fn}
    on_destroy::Ptr{aws_http_on_stream_destroy_fn}
end

# typedef void aws_http_stream_write_complete_fn ( struct aws_http_stream * stream , int error_code , void * user_data )
"""
Invoked when the data stream of an outgoing HTTP write operation is no longer in use. This is always invoked on the HTTP connection's event-loop thread.

# Arguments
* `stream`: HTTP-stream this write operation was submitted to.
* `error_code`: If error\\_code is AWS\\_ERROR\\_SUCCESS (0), the data was successfully sent. Any other error\\_code indicates that the HTTP-stream is in the process of terminating. If the error\\_code is AWS\\_ERROR\\_HTTP\\_STREAM\\_HAS\\_COMPLETED, the stream's termination has nothing to do with this write operation. Any other non-zero error code indicates a problem with this particular write operation's data.
* `user_data`: User data for this write operation.
"""
const aws_http_stream_write_complete_fn = Cvoid

"""
Invoked when the data of an outgoing HTTP/1.1 chunk is no longer in use. This is always invoked on the HTTP connection's event-loop thread.

# Arguments
* `stream`: HTTP-stream this chunk was submitted to.
* `error_code`: If error\\_code is AWS\\_ERROR\\_SUCCESS (0), the data was successfully sent. Any other error\\_code indicates that the HTTP-stream is in the process of terminating. If the error\\_code is AWS\\_ERROR\\_HTTP\\_STREAM\\_HAS\\_COMPLETED, the stream's termination has nothing to do with this chunk. Any other non-zero error code indicates a problem with this particular chunk's data.
* `user_data`: User data for this chunk.
"""
const aws_http1_stream_write_chunk_complete_fn = aws_http_stream_write_complete_fn

"""
    aws_http1_chunk_extension

HTTP/1.1 chunk extension for chunked encoding. Note that the underlying strings are not owned by the byte cursors.
"""
struct aws_http1_chunk_extension
    key::aws_byte_cursor
    value::aws_byte_cursor
end

"""
    aws_http1_chunk_options

Encoding options for an HTTP/1.1 chunked transfer encoding chunk.
"""
struct aws_http1_chunk_options
    chunk_data::Ptr{aws_input_stream}
    chunk_data_size::UInt64
    extensions::Ptr{aws_http1_chunk_extension}
    num_extensions::Csize_t
    on_complete::Ptr{aws_http1_stream_write_chunk_complete_fn}
    user_data::Ptr{Cvoid}
end

"""
Invoked when the data of an outgoing HTTP2 data frame is no longer in use. This is always invoked on the HTTP connection's event-loop thread.

# Arguments
* `stream`: HTTP2-stream this write was submitted to.
* `error_code`: If error\\_code is AWS\\_ERROR\\_SUCCESS (0), the data was successfully sent. Any other error\\_code indicates that the HTTP-stream is in the process of terminating. If the error\\_code is AWS\\_ERROR\\_HTTP\\_STREAM\\_HAS\\_COMPLETED, the stream's termination has nothing to do with this write. Any other non-zero error code indicates a problem with this particular write's data.
* `user_data`: User data for this write.
"""
const aws_http2_stream_write_data_complete_fn = aws_http_stream_write_complete_fn

"""
    aws_http2_stream_write_data_options

Encoding options for manual H2 data frame writes
"""
struct aws_http2_stream_write_data_options
    data::Ptr{aws_input_stream}
    end_stream::Bool
    on_complete::Ptr{aws_http2_stream_write_data_complete_fn}
    user_data::Ptr{Cvoid}
end

"""
    aws_http_header_name_eq(name_a, name_b)

Return whether both names are equivalent. This is a case-insensitive string comparison.

Example Matches: "Content-Length" == "content-length" // upper or lower case ok

Example Mismatches: "Content-Length" != " Content-Length" // leading whitespace bad

### Prototype
```c
bool aws_http_header_name_eq(struct aws_byte_cursor name_a, struct aws_byte_cursor name_b);
```
"""
function aws_http_header_name_eq(name_a, name_b)
    ccall((:aws_http_header_name_eq, libaws_c_http), Bool, (aws_byte_cursor, aws_byte_cursor), name_a, name_b)
end

"""
    aws_http_headers_new(allocator)

Create a new headers object. The caller has a hold on the object and must call [`aws_http_headers_release`](@ref)() when they are done with it.

### Prototype
```c
struct aws_http_headers *aws_http_headers_new(struct aws_allocator *allocator);
```
"""
function aws_http_headers_new(allocator)
    ccall((:aws_http_headers_new, libaws_c_http), Ptr{aws_http_headers}, (Ptr{aws_allocator},), allocator)
end

"""
    aws_http_headers_acquire(headers)

Acquire a hold on the object, preventing it from being deleted until [`aws_http_headers_release`](@ref)() is called by all those with a hold on it.

### Prototype
```c
void aws_http_headers_acquire(struct aws_http_headers *headers);
```
"""
function aws_http_headers_acquire(headers)
    ccall((:aws_http_headers_acquire, libaws_c_http), Cvoid, (Ptr{aws_http_headers},), headers)
end

"""
    aws_http_headers_release(headers)

Release a hold on the object. The object is deleted when all holds on it are released.

### Prototype
```c
void aws_http_headers_release(struct aws_http_headers *headers);
```
"""
function aws_http_headers_release(headers)
    ccall((:aws_http_headers_release, libaws_c_http), Cvoid, (Ptr{aws_http_headers},), headers)
end

"""
    aws_http_headers_add_header(headers, header)

Add a header. The underlying strings are copied.

### Prototype
```c
int aws_http_headers_add_header(struct aws_http_headers *headers, const struct aws_http_header *header);
```
"""
function aws_http_headers_add_header(headers, header)
    ccall((:aws_http_headers_add_header, libaws_c_http), Cint, (Ptr{aws_http_headers}, Ptr{aws_http_header}), headers, header)
end

"""
    aws_http_headers_add(headers, name, value)

Add a header. The underlying strings are copied.

### Prototype
```c
int aws_http_headers_add(struct aws_http_headers *headers, struct aws_byte_cursor name, struct aws_byte_cursor value);
```
"""
function aws_http_headers_add(headers, name, value)
    ccall((:aws_http_headers_add, libaws_c_http), Cint, (Ptr{aws_http_headers}, aws_byte_cursor, aws_byte_cursor), headers, name, value)
end

"""
    aws_http_headers_add_array(headers, array, count)

Add an array of headers. The underlying strings are copied.

### Prototype
```c
int aws_http_headers_add_array(struct aws_http_headers *headers, const struct aws_http_header *array, size_t count);
```
"""
function aws_http_headers_add_array(headers, array, count)
    ccall((:aws_http_headers_add_array, libaws_c_http), Cint, (Ptr{aws_http_headers}, Ptr{aws_http_header}, Csize_t), headers, array, count)
end

"""
    aws_http_headers_set(headers, name, value)

Set a header value. The header is added if necessary and any existing values for this name are removed. The underlying strings are copied.

### Prototype
```c
int aws_http_headers_set(struct aws_http_headers *headers, struct aws_byte_cursor name, struct aws_byte_cursor value);
```
"""
function aws_http_headers_set(headers, name, value)
    ccall((:aws_http_headers_set, libaws_c_http), Cint, (Ptr{aws_http_headers}, aws_byte_cursor, aws_byte_cursor), headers, name, value)
end

"""
    aws_http_headers_count(headers)

Get the total number of headers.

### Prototype
```c
size_t aws_http_headers_count(const struct aws_http_headers *headers);
```
"""
function aws_http_headers_count(headers)
    ccall((:aws_http_headers_count, libaws_c_http), Csize_t, (Ptr{aws_http_headers},), headers)
end

"""
    aws_http_headers_get_index(headers, index, out_header)

Get the header at the specified index. The index of a given header may change any time headers are modified. When iterating headers, the following ordering rules apply:

- Headers with the same name will always be in the same order, relative to one another. If "A: one" is added before "A: two", then "A: one" will always precede "A: two".

- Headers with different names could be in any order, relative to one another. If "A: one" is seen before "B: bee" in one iteration, you might see "B: bee" before "A: one" on the next.

AWS\\_ERROR\\_INVALID\\_INDEX is raised if the index is invalid.

### Prototype
```c
int aws_http_headers_get_index( const struct aws_http_headers *headers, size_t index, struct aws_http_header *out_header);
```
"""
function aws_http_headers_get_index(headers, index, out_header)
    ccall((:aws_http_headers_get_index, libaws_c_http), Cint, (Ptr{aws_http_headers}, Csize_t, Ptr{aws_http_header}), headers, index, out_header)
end

"""
    aws_http_headers_get_all(headers, name)

Get all values with this name, combined into one new aws\\_string that you are responsible for destroying. If there are multiple headers with this name, their values are appended with comma-separators. If there are no headers with this name, NULL is returned and AWS\\_ERROR\\_HTTP\\_HEADER\\_NOT\\_FOUND is raised.

### Prototype
```c
struct aws_string *aws_http_headers_get_all(const struct aws_http_headers *headers, struct aws_byte_cursor name);
```
"""
function aws_http_headers_get_all(headers, name)
    ccall((:aws_http_headers_get_all, libaws_c_http), Ptr{Cvoid}, (Ptr{aws_http_headers}, aws_byte_cursor), headers, name)
end

"""
    aws_http_headers_get(headers, name, out_value)

Get the first value for this name, ignoring any additional values. AWS\\_ERROR\\_HTTP\\_HEADER\\_NOT\\_FOUND is raised if the name is not found.

### Prototype
```c
int aws_http_headers_get( const struct aws_http_headers *headers, struct aws_byte_cursor name, struct aws_byte_cursor *out_value);
```
"""
function aws_http_headers_get(headers, name, out_value)
    ccall((:aws_http_headers_get, libaws_c_http), Cint, (Ptr{aws_http_headers}, aws_byte_cursor, Ptr{aws_byte_cursor}), headers, name, out_value)
end

"""
    aws_http_headers_has(headers, name)

Test if header name exists or not in headers

### Prototype
```c
bool aws_http_headers_has(const struct aws_http_headers *headers, struct aws_byte_cursor name);
```
"""
function aws_http_headers_has(headers, name)
    ccall((:aws_http_headers_has, libaws_c_http), Bool, (Ptr{aws_http_headers}, aws_byte_cursor), headers, name)
end

"""
    aws_http_headers_erase(headers, name)

Remove all headers with this name. AWS\\_ERROR\\_HTTP\\_HEADER\\_NOT\\_FOUND is raised if no headers with this name are found.

### Prototype
```c
int aws_http_headers_erase(struct aws_http_headers *headers, struct aws_byte_cursor name);
```
"""
function aws_http_headers_erase(headers, name)
    ccall((:aws_http_headers_erase, libaws_c_http), Cint, (Ptr{aws_http_headers}, aws_byte_cursor), headers, name)
end

"""
    aws_http_headers_erase_value(headers, name, value)

Remove the first header found with this name and value. AWS\\_ERROR\\_HTTP\\_HEADER\\_NOT\\_FOUND is raised if no such header is found.

### Prototype
```c
int aws_http_headers_erase_value( struct aws_http_headers *headers, struct aws_byte_cursor name, struct aws_byte_cursor value);
```
"""
function aws_http_headers_erase_value(headers, name, value)
    ccall((:aws_http_headers_erase_value, libaws_c_http), Cint, (Ptr{aws_http_headers}, aws_byte_cursor, aws_byte_cursor), headers, name, value)
end

"""
    aws_http_headers_erase_index(headers, index)

Remove the header at the specified index.

AWS\\_ERROR\\_INVALID\\_INDEX is raised if the index is invalid.

### Prototype
```c
int aws_http_headers_erase_index(struct aws_http_headers *headers, size_t index);
```
"""
function aws_http_headers_erase_index(headers, index)
    ccall((:aws_http_headers_erase_index, libaws_c_http), Cint, (Ptr{aws_http_headers}, Csize_t), headers, index)
end

"""
    aws_http_headers_clear(headers)

Clear all headers.

### Prototype
```c
void aws_http_headers_clear(struct aws_http_headers *headers);
```
"""
function aws_http_headers_clear(headers)
    ccall((:aws_http_headers_clear, libaws_c_http), Cvoid, (Ptr{aws_http_headers},), headers)
end

"""
    aws_http2_headers_get_request_method(h2_headers, out_method)

Get the `:method` value (HTTP/2 headers only).

### Prototype
```c
int aws_http2_headers_get_request_method(const struct aws_http_headers *h2_headers, struct aws_byte_cursor *out_method);
```
"""
function aws_http2_headers_get_request_method(h2_headers, out_method)
    ccall((:aws_http2_headers_get_request_method, libaws_c_http), Cint, (Ptr{aws_http_headers}, Ptr{aws_byte_cursor}), h2_headers, out_method)
end

"""
    aws_http2_headers_set_request_method(h2_headers, method)

Set `:method` (HTTP/2 headers only). The headers makes its own copy of the underlying string.

### Prototype
```c
int aws_http2_headers_set_request_method(struct aws_http_headers *h2_headers, struct aws_byte_cursor method);
```
"""
function aws_http2_headers_set_request_method(h2_headers, method)
    ccall((:aws_http2_headers_set_request_method, libaws_c_http), Cint, (Ptr{aws_http_headers}, aws_byte_cursor), h2_headers, method)
end

"""
    aws_http2_headers_get_request_scheme(h2_headers, out_scheme)

Documentation not found.
### Prototype
```c
int aws_http2_headers_get_request_scheme(const struct aws_http_headers *h2_headers, struct aws_byte_cursor *out_scheme);
```
"""
function aws_http2_headers_get_request_scheme(h2_headers, out_scheme)
    ccall((:aws_http2_headers_get_request_scheme, libaws_c_http), Cint, (Ptr{aws_http_headers}, Ptr{aws_byte_cursor}), h2_headers, out_scheme)
end

"""
    aws_http2_headers_set_request_scheme(h2_headers, scheme)

Set `:scheme` (request pseudo headers only). The pseudo headers makes its own copy of the underlying string.

### Prototype
```c
int aws_http2_headers_set_request_scheme(struct aws_http_headers *h2_headers, struct aws_byte_cursor scheme);
```
"""
function aws_http2_headers_set_request_scheme(h2_headers, scheme)
    ccall((:aws_http2_headers_set_request_scheme, libaws_c_http), Cint, (Ptr{aws_http_headers}, aws_byte_cursor), h2_headers, scheme)
end

"""
    aws_http2_headers_get_request_authority(h2_headers, out_authority)

Documentation not found.
### Prototype
```c
int aws_http2_headers_get_request_authority( const struct aws_http_headers *h2_headers, struct aws_byte_cursor *out_authority);
```
"""
function aws_http2_headers_get_request_authority(h2_headers, out_authority)
    ccall((:aws_http2_headers_get_request_authority, libaws_c_http), Cint, (Ptr{aws_http_headers}, Ptr{aws_byte_cursor}), h2_headers, out_authority)
end

"""
    aws_http2_headers_set_request_authority(h2_headers, authority)

Set `:authority` (request pseudo headers only). The pseudo headers makes its own copy of the underlying string.

### Prototype
```c
int aws_http2_headers_set_request_authority(struct aws_http_headers *h2_headers, struct aws_byte_cursor authority);
```
"""
function aws_http2_headers_set_request_authority(h2_headers, authority)
    ccall((:aws_http2_headers_set_request_authority, libaws_c_http), Cint, (Ptr{aws_http_headers}, aws_byte_cursor), h2_headers, authority)
end

"""
    aws_http2_headers_get_request_path(h2_headers, out_path)

Documentation not found.
### Prototype
```c
int aws_http2_headers_get_request_path(const struct aws_http_headers *h2_headers, struct aws_byte_cursor *out_path);
```
"""
function aws_http2_headers_get_request_path(h2_headers, out_path)
    ccall((:aws_http2_headers_get_request_path, libaws_c_http), Cint, (Ptr{aws_http_headers}, Ptr{aws_byte_cursor}), h2_headers, out_path)
end

"""
    aws_http2_headers_set_request_path(h2_headers, path)

Set `:path` (request pseudo headers only). The pseudo headers makes its own copy of the underlying string.

### Prototype
```c
int aws_http2_headers_set_request_path(struct aws_http_headers *h2_headers, struct aws_byte_cursor path);
```
"""
function aws_http2_headers_set_request_path(h2_headers, path)
    ccall((:aws_http2_headers_set_request_path, libaws_c_http), Cint, (Ptr{aws_http_headers}, aws_byte_cursor), h2_headers, path)
end

"""
    aws_http2_headers_get_response_status(h2_headers, out_status_code)

Get `:status` (response pseudo headers only). If no status is set, AWS\\_ERROR\\_HTTP\\_DATA\\_NOT\\_AVAILABLE is raised.

### Prototype
```c
int aws_http2_headers_get_response_status(const struct aws_http_headers *h2_headers, int *out_status_code);
```
"""
function aws_http2_headers_get_response_status(h2_headers, out_status_code)
    ccall((:aws_http2_headers_get_response_status, libaws_c_http), Cint, (Ptr{aws_http_headers}, Ptr{Cint}), h2_headers, out_status_code)
end

"""
    aws_http2_headers_set_response_status(h2_headers, status_code)

Set `:status` (response pseudo headers only).

### Prototype
```c
int aws_http2_headers_set_response_status(struct aws_http_headers *h2_headers, int status_code);
```
"""
function aws_http2_headers_set_response_status(h2_headers, status_code)
    ccall((:aws_http2_headers_set_response_status, libaws_c_http), Cint, (Ptr{aws_http_headers}, Cint), h2_headers, status_code)
end

"""
    aws_http_message_new_request(allocator)

Create a new HTTP/1.1 request message. The message is blank, all properties (method, path, etc) must be set individually. If HTTP/1.1 message used in HTTP/2 connection, the transformation will be automatically applied. A HTTP/2 message will created and sent based on the HTTP/1.1 message.

The caller has a hold on the object and must call [`aws_http_message_release`](@ref)() when they are done with it.

### Prototype
```c
struct aws_http_message *aws_http_message_new_request(struct aws_allocator *allocator);
```
"""
function aws_http_message_new_request(allocator)
    ccall((:aws_http_message_new_request, libaws_c_http), Ptr{aws_http_message}, (Ptr{aws_allocator},), allocator)
end

"""
    aws_http_message_new_request_with_headers(allocator, existing_headers)

Like [`aws_http_message_new_request`](@ref)(), but uses existing [`aws_http_headers`](@ref) instead of creating a new one. Acquires a hold on the headers, and releases it when the request is destroyed.

### Prototype
```c
struct aws_http_message *aws_http_message_new_request_with_headers( struct aws_allocator *allocator, struct aws_http_headers *existing_headers);
```
"""
function aws_http_message_new_request_with_headers(allocator, existing_headers)
    ccall((:aws_http_message_new_request_with_headers, libaws_c_http), Ptr{aws_http_message}, (Ptr{aws_allocator}, Ptr{aws_http_headers}), allocator, existing_headers)
end

"""
    aws_http_message_new_response(allocator)

Create a new HTTP/1.1 response message. The message is blank, all properties (status, headers, etc) must be set individually.

The caller has a hold on the object and must call [`aws_http_message_release`](@ref)() when they are done with it.

### Prototype
```c
struct aws_http_message *aws_http_message_new_response(struct aws_allocator *allocator);
```
"""
function aws_http_message_new_response(allocator)
    ccall((:aws_http_message_new_response, libaws_c_http), Ptr{aws_http_message}, (Ptr{aws_allocator},), allocator)
end

"""
    aws_http2_message_new_request(allocator)

Create a new HTTP/2 request message. pseudo headers need to be set from aws\\_http2\\_headers\\_set\\_request\\_* to the headers of the [`aws_http_message`](@ref). Will be errored out if used in HTTP/1.1 connection.

The caller has a hold on the object and must call [`aws_http_message_release`](@ref)() when they are done with it.

### Prototype
```c
struct aws_http_message *aws_http2_message_new_request(struct aws_allocator *allocator);
```
"""
function aws_http2_message_new_request(allocator)
    ccall((:aws_http2_message_new_request, libaws_c_http), Ptr{aws_http_message}, (Ptr{aws_allocator},), allocator)
end

"""
    aws_http2_message_new_response(allocator)

Create a new HTTP/2 response message. pseudo headers need to be set from [`aws_http2_headers_set_response_status`](@ref) to the headers of the [`aws_http_message`](@ref). Will be errored out if used in HTTP/1.1 connection.

The caller has a hold on the object and must call [`aws_http_message_release`](@ref)() when they are done with it.

### Prototype
```c
struct aws_http_message *aws_http2_message_new_response(struct aws_allocator *allocator);
```
"""
function aws_http2_message_new_response(allocator)
    ccall((:aws_http2_message_new_response, libaws_c_http), Ptr{aws_http_message}, (Ptr{aws_allocator},), allocator)
end

"""
    aws_http2_message_new_from_http1(alloc, http1_msg)

Create an HTTP/2 message from HTTP/1.1 message. pseudo headers will be created from the context and added to the headers of new message. Normal headers will be copied to the headers of new message. Note: - if `host` exist, it will be removed and `:authority` will be added using the information. - `:scheme` always defaults to "https". To use a different scheme create the HTTP/2 message directly

### Prototype
```c
struct aws_http_message *aws_http2_message_new_from_http1( struct aws_allocator *alloc, const struct aws_http_message *http1_msg);
```
"""
function aws_http2_message_new_from_http1(alloc, http1_msg)
    ccall((:aws_http2_message_new_from_http1, libaws_c_http), Ptr{aws_http_message}, (Ptr{aws_allocator}, Ptr{aws_http_message}), alloc, http1_msg)
end

"""
    aws_http_message_acquire(message)

Acquire a hold on the object, preventing it from being deleted until [`aws_http_message_release`](@ref)() is called by all those with a hold on it.

This function returns the passed in message (possibly NULL) so that acquire-and-assign can be done with a single statement.

### Prototype
```c
struct aws_http_message *aws_http_message_acquire(struct aws_http_message *message);
```
"""
function aws_http_message_acquire(message)
    ccall((:aws_http_message_acquire, libaws_c_http), Ptr{aws_http_message}, (Ptr{aws_http_message},), message)
end

"""
    aws_http_message_release(message)

Release a hold on the object. The object is deleted when all holds on it are released.

This function always returns NULL so that release-and-assign-NULL can be done with a single statement.

### Prototype
```c
struct aws_http_message *aws_http_message_release(struct aws_http_message *message);
```
"""
function aws_http_message_release(message)
    ccall((:aws_http_message_release, libaws_c_http), Ptr{aws_http_message}, (Ptr{aws_http_message},), message)
end

"""
    aws_http_message_destroy(message)

Deprecated. This is equivalent to [`aws_http_message_release`](@ref)().

### Prototype
```c
void aws_http_message_destroy(struct aws_http_message *message);
```
"""
function aws_http_message_destroy(message)
    ccall((:aws_http_message_destroy, libaws_c_http), Cvoid, (Ptr{aws_http_message},), message)
end

"""
    aws_http_message_is_request(message)

Documentation not found.
### Prototype
```c
bool aws_http_message_is_request(const struct aws_http_message *message);
```
"""
function aws_http_message_is_request(message)
    ccall((:aws_http_message_is_request, libaws_c_http), Bool, (Ptr{aws_http_message},), message)
end

"""
    aws_http_message_is_response(message)

Documentation not found.
### Prototype
```c
bool aws_http_message_is_response(const struct aws_http_message *message);
```
"""
function aws_http_message_is_response(message)
    ccall((:aws_http_message_is_response, libaws_c_http), Bool, (Ptr{aws_http_message},), message)
end

"""
    aws_http_message_get_protocol_version(message)

Get the protocol version of the http message.

### Prototype
```c
enum aws_http_version aws_http_message_get_protocol_version(const struct aws_http_message *message);
```
"""
function aws_http_message_get_protocol_version(message)
    ccall((:aws_http_message_get_protocol_version, libaws_c_http), aws_http_version, (Ptr{aws_http_message},), message)
end

"""
    aws_http_message_get_request_method(request_message, out_method)

Get the method (request messages only).

### Prototype
```c
int aws_http_message_get_request_method( const struct aws_http_message *request_message, struct aws_byte_cursor *out_method);
```
"""
function aws_http_message_get_request_method(request_message, out_method)
    ccall((:aws_http_message_get_request_method, libaws_c_http), Cint, (Ptr{aws_http_message}, Ptr{aws_byte_cursor}), request_message, out_method)
end

"""
    aws_http_message_set_request_method(request_message, method)

Set the method (request messages only). The request makes its own copy of the underlying string.

### Prototype
```c
int aws_http_message_set_request_method(struct aws_http_message *request_message, struct aws_byte_cursor method);
```
"""
function aws_http_message_set_request_method(request_message, method)
    ccall((:aws_http_message_set_request_method, libaws_c_http), Cint, (Ptr{aws_http_message}, aws_byte_cursor), request_message, method)
end

"""
    aws_http_message_get_request_path(request_message, out_path)

Documentation not found.
### Prototype
```c
int aws_http_message_get_request_path(const struct aws_http_message *request_message, struct aws_byte_cursor *out_path);
```
"""
function aws_http_message_get_request_path(request_message, out_path)
    ccall((:aws_http_message_get_request_path, libaws_c_http), Cint, (Ptr{aws_http_message}, Ptr{aws_byte_cursor}), request_message, out_path)
end

"""
    aws_http_message_set_request_path(request_message, path)

Set the path-and-query value (request messages only). The request makes its own copy of the underlying string.

### Prototype
```c
int aws_http_message_set_request_path(struct aws_http_message *request_message, struct aws_byte_cursor path);
```
"""
function aws_http_message_set_request_path(request_message, path)
    ccall((:aws_http_message_set_request_path, libaws_c_http), Cint, (Ptr{aws_http_message}, aws_byte_cursor), request_message, path)
end

"""
    aws_http_message_get_response_status(response_message, out_status_code)

Get the status code (response messages only). If no status is set, AWS\\_ERROR\\_HTTP\\_DATA\\_NOT\\_AVAILABLE is raised.

### Prototype
```c
int aws_http_message_get_response_status(const struct aws_http_message *response_message, int *out_status_code);
```
"""
function aws_http_message_get_response_status(response_message, out_status_code)
    ccall((:aws_http_message_get_response_status, libaws_c_http), Cint, (Ptr{aws_http_message}, Ptr{Cint}), response_message, out_status_code)
end

"""
    aws_http_message_set_response_status(response_message, status_code)

Set the status code (response messages only).

### Prototype
```c
int aws_http_message_set_response_status(struct aws_http_message *response_message, int status_code);
```
"""
function aws_http_message_set_response_status(response_message, status_code)
    ccall((:aws_http_message_set_response_status, libaws_c_http), Cint, (Ptr{aws_http_message}, Cint), response_message, status_code)
end

"""
    aws_http_message_get_body_stream(message)

Get the body stream. Returns NULL if no body stream is set.

### Prototype
```c
struct aws_input_stream *aws_http_message_get_body_stream(const struct aws_http_message *message);
```
"""
function aws_http_message_get_body_stream(message)
    ccall((:aws_http_message_get_body_stream, libaws_c_http), Ptr{aws_input_stream}, (Ptr{aws_http_message},), message)
end

"""
    aws_http_message_set_body_stream(message, body_stream)

Set the body stream. NULL is an acceptable value for messages with no body. Note: The message does NOT take ownership of the body stream. The stream must not be destroyed until the message is complete.

### Prototype
```c
void aws_http_message_set_body_stream(struct aws_http_message *message, struct aws_input_stream *body_stream);
```
"""
function aws_http_message_set_body_stream(message, body_stream)
    ccall((:aws_http_message_set_body_stream, libaws_c_http), Cvoid, (Ptr{aws_http_message}, Ptr{aws_input_stream}), message, body_stream)
end

"""
Documentation not found.
"""
mutable struct aws_future_http_message end

"""
    aws_future_http_message_new(alloc)

Documentation not found.
### Prototype
```c
AWS_FUTURE_T_POINTER_WITH_RELEASE_DECLARATION(aws_future_http_message, struct aws_http_message, AWS_HTTP_API);
```
"""
function aws_future_http_message_new(alloc)
    ccall((:aws_future_http_message_new, libaws_c_http), Ptr{aws_future_http_message}, (Ptr{aws_allocator},), alloc)
end

"""
    aws_future_http_message_set_result_by_move(future, pointer_address)

Documentation not found.
### Prototype
```c
AWS_FUTURE_T_POINTER_WITH_RELEASE_DECLARATION(aws_future_http_message, struct aws_http_message, AWS_HTTP_API);
```
"""
function aws_future_http_message_set_result_by_move(future, pointer_address)
    ccall((:aws_future_http_message_set_result_by_move, libaws_c_http), Cvoid, (Ptr{aws_future_http_message}, Ptr{Ptr{aws_http_message}}), future, pointer_address)
end

"""
    aws_future_http_message_get_result_by_move(future)

Documentation not found.
### Prototype
```c
AWS_FUTURE_T_POINTER_WITH_RELEASE_DECLARATION(aws_future_http_message, struct aws_http_message, AWS_HTTP_API);
```
"""
function aws_future_http_message_get_result_by_move(future)
    ccall((:aws_future_http_message_get_result_by_move, libaws_c_http), Ptr{aws_http_message}, (Ptr{aws_future_http_message},), future)
end

"""
    aws_future_http_message_peek_result(future)

Documentation not found.
### Prototype
```c
AWS_FUTURE_T_POINTER_WITH_RELEASE_DECLARATION(aws_future_http_message, struct aws_http_message, AWS_HTTP_API);
```
"""
function aws_future_http_message_peek_result(future)
    ccall((:aws_future_http_message_peek_result, libaws_c_http), Ptr{aws_http_message}, (Ptr{aws_future_http_message},), future)
end

"""
    aws_future_http_message_acquire(future)

Documentation not found.
### Prototype
```c
AWS_FUTURE_T_POINTER_WITH_RELEASE_DECLARATION(aws_future_http_message, struct aws_http_message, AWS_HTTP_API);
```
"""
function aws_future_http_message_acquire(future)
    ccall((:aws_future_http_message_acquire, libaws_c_http), Ptr{aws_future_http_message}, (Ptr{aws_future_http_message},), future)
end

"""
    aws_future_http_message_release(future)

Documentation not found.
### Prototype
```c
AWS_FUTURE_T_POINTER_WITH_RELEASE_DECLARATION(aws_future_http_message, struct aws_http_message, AWS_HTTP_API);
```
"""
function aws_future_http_message_release(future)
    ccall((:aws_future_http_message_release, libaws_c_http), Ptr{aws_future_http_message}, (Ptr{aws_future_http_message},), future)
end

"""
    aws_future_http_message_set_error(future, error_code)

Documentation not found.
### Prototype
```c
AWS_FUTURE_T_POINTER_WITH_RELEASE_DECLARATION(aws_future_http_message, struct aws_http_message, AWS_HTTP_API);
```
"""
function aws_future_http_message_set_error(future, error_code)
    ccall((:aws_future_http_message_set_error, libaws_c_http), Cvoid, (Ptr{aws_future_http_message}, Cint), future, error_code)
end

"""
    aws_future_http_message_is_done(future)

Documentation not found.
### Prototype
```c
AWS_FUTURE_T_POINTER_WITH_RELEASE_DECLARATION(aws_future_http_message, struct aws_http_message, AWS_HTTP_API);
```
"""
function aws_future_http_message_is_done(future)
    ccall((:aws_future_http_message_is_done, libaws_c_http), Bool, (Ptr{aws_future_http_message},), future)
end

"""
    aws_future_http_message_get_error(future)

Documentation not found.
### Prototype
```c
AWS_FUTURE_T_POINTER_WITH_RELEASE_DECLARATION(aws_future_http_message, struct aws_http_message, AWS_HTTP_API);
```
"""
function aws_future_http_message_get_error(future)
    ccall((:aws_future_http_message_get_error, libaws_c_http), Cint, (Ptr{aws_future_http_message},), future)
end

"""
    aws_future_http_message_register_callback(future, on_done, user_data)

Documentation not found.
### Prototype
```c
AWS_FUTURE_T_POINTER_WITH_RELEASE_DECLARATION(aws_future_http_message, struct aws_http_message, AWS_HTTP_API);
```
"""
function aws_future_http_message_register_callback(future, on_done, user_data)
    ccall((:aws_future_http_message_register_callback, libaws_c_http), Cvoid, (Ptr{aws_future_http_message}, Ptr{aws_future_callback_fn}, Ptr{Cvoid}), future, on_done, user_data)
end

"""
    aws_future_http_message_register_callback_if_not_done(future, on_done, user_data)

Documentation not found.
### Prototype
```c
AWS_FUTURE_T_POINTER_WITH_RELEASE_DECLARATION(aws_future_http_message, struct aws_http_message, AWS_HTTP_API);
```
"""
function aws_future_http_message_register_callback_if_not_done(future, on_done, user_data)
    ccall((:aws_future_http_message_register_callback_if_not_done, libaws_c_http), Bool, (Ptr{aws_future_http_message}, Ptr{aws_future_callback_fn}, Ptr{Cvoid}), future, on_done, user_data)
end

"""
    aws_future_http_message_register_event_loop_callback(future, event_loop, on_done, user_data)

Documentation not found.
### Prototype
```c
AWS_FUTURE_T_POINTER_WITH_RELEASE_DECLARATION(aws_future_http_message, struct aws_http_message, AWS_HTTP_API);
```
"""
function aws_future_http_message_register_event_loop_callback(future, event_loop, on_done, user_data)
    ccall((:aws_future_http_message_register_event_loop_callback, libaws_c_http), Cvoid, (Ptr{aws_future_http_message}, Ptr{aws_event_loop}, Ptr{aws_future_callback_fn}, Ptr{Cvoid}), future, event_loop, on_done, user_data)
end

"""
    aws_future_http_message_register_channel_callback(future, channel, on_done, user_data)

Documentation not found.
### Prototype
```c
AWS_FUTURE_T_POINTER_WITH_RELEASE_DECLARATION(aws_future_http_message, struct aws_http_message, AWS_HTTP_API);
```
"""
function aws_future_http_message_register_channel_callback(future, channel, on_done, user_data)
    ccall((:aws_future_http_message_register_channel_callback, libaws_c_http), Cvoid, (Ptr{aws_future_http_message}, Ptr{Cvoid}, Ptr{aws_future_callback_fn}, Ptr{Cvoid}), future, channel, on_done, user_data)
end

"""
    aws_future_http_message_wait(future, timeout_ns)

Documentation not found.
### Prototype
```c
AWS_FUTURE_T_POINTER_WITH_RELEASE_DECLARATION(aws_future_http_message, struct aws_http_message, AWS_HTTP_API);
```
"""
function aws_future_http_message_wait(future, timeout_ns)
    ccall((:aws_future_http_message_wait, libaws_c_http), Bool, (Ptr{aws_future_http_message}, UInt64), future, timeout_ns)
end

"""
    aws_http1_stream_write_chunk(http1_stream, options)

Submit a chunk of data to be sent on an HTTP/1.1 stream. The stream must have specified "chunked" in a "transfer-encoding" header, and the [`aws_http_message`](@ref) must NOT have any body stream set. For client streams, activate() must be called before any chunks are submitted. For server streams, the response must be submitted before any chunks. A final chunk with size 0 must be submitted to successfully complete the HTTP-stream.

Returns AWS\\_OP\\_SUCCESS if the chunk has been submitted. The chunk's completion callback will be invoked when the HTTP-stream is done with the chunk data, whether or not it was successfully sent (see [`aws_http1_stream_write_chunk_complete_fn`](@ref)). The chunk data must remain valid until the completion callback is invoked.

Returns AWS\\_OP\\_ERR and raises an error if the chunk could not be submitted. In this case, the chunk's completion callback will never be invoked. Note that it is always possible for the HTTP-stream to terminate unexpectedly prior to this call being made, in which case the error raised is AWS\\_ERROR\\_HTTP\\_STREAM\\_HAS\\_COMPLETED.

### Prototype
```c
int aws_http1_stream_write_chunk( struct aws_http_stream *http1_stream, const struct aws_http1_chunk_options *options);
```
"""
function aws_http1_stream_write_chunk(http1_stream, options)
    ccall((:aws_http1_stream_write_chunk, libaws_c_http), Cint, (Ptr{aws_http_stream}, Ptr{aws_http1_chunk_options}), http1_stream, options)
end

"""
    aws_http2_stream_write_data(http2_stream, options)

The stream must have specified `http2_use_manual_data_writes` during request creation. For client streams, activate() must be called before any frames are submitted. For server streams, the response headers must be submitted before any frames. A write with options that has end\\_stream set to be true will end the stream and prevent any further write.

Typical usage will be something like: options.http2\\_use\\_manual\\_data\\_writes = true; stream = [`aws_http_connection_make_request`](@ref)(connection, &options); [`aws_http_stream_activate`](@ref)(stream); ... struct [`aws_http2_stream_write_data_options`](@ref) write; [`aws_http2_stream_write_data`](@ref)(stream, &write); ... struct [`aws_http2_stream_write_data_options`](@ref) last\\_write; last\\_write.end\\_stream = true; [`aws_http2_stream_write_data`](@ref)(stream, &write); ... [`aws_http_stream_release`](@ref)(stream);

# Returns
AWS\\_OP\\_SUCCESS if the write was queued AWS\\_OP\\_ERROR indicating the attempt raised an error code. AWS\\_ERROR\\_INVALID\\_STATE will be raised for invalid usage. AWS\\_ERROR\\_HTTP\\_STREAM\\_HAS\\_COMPLETED will be raised if the stream ended for reasons behind the scenes.
### Prototype
```c
int aws_http2_stream_write_data( struct aws_http_stream *http2_stream, const struct aws_http2_stream_write_data_options *options);
```
"""
function aws_http2_stream_write_data(http2_stream, options)
    ccall((:aws_http2_stream_write_data, libaws_c_http), Cint, (Ptr{aws_http_stream}, Ptr{aws_http2_stream_write_data_options}), http2_stream, options)
end

"""
    aws_http1_stream_add_chunked_trailer(http1_stream, trailing_headers)

Add a list of headers to be added as trailing headers sent after the last chunk is sent. a "Trailer" header field which indicates the fields present in the trailer.

Certain headers are forbidden in the trailer (e.g., Transfer-Encoding, Content-Length, Host). See RFC-7541 Section 4.1.2 for more details.

For client streams, activate() must be called before any chunks are submitted.

For server streams, the response must be submitted before the trailer can be added

[`aws_http1_stream_add_chunked_trailer`](@ref) must be called before the final size 0 chunk, and at the moment can only be called once, though this could change if need be.

Returns AWS\\_OP\\_SUCCESS if the chunk has been submitted.

### Prototype
```c
int aws_http1_stream_add_chunked_trailer( struct aws_http_stream *http1_stream, const struct aws_http_headers *trailing_headers);
```
"""
function aws_http1_stream_add_chunked_trailer(http1_stream, trailing_headers)
    ccall((:aws_http1_stream_add_chunked_trailer, libaws_c_http), Cint, (Ptr{aws_http_stream}, Ptr{aws_http_headers}), http1_stream, trailing_headers)
end

"""
    aws_http_message_get_headers(message)

This datastructure has more functions for inspecting and modifying headers than are available on the [`aws_http_message`](@ref) datastructure.

### Prototype
```c
struct aws_http_headers *aws_http_message_get_headers(const struct aws_http_message *message);
```
"""
function aws_http_message_get_headers(message)
    ccall((:aws_http_message_get_headers, libaws_c_http), Ptr{aws_http_headers}, (Ptr{aws_http_message},), message)
end

"""
    aws_http_message_get_const_headers(message)

Get the message's const [`aws_http_headers`](@ref).

### Prototype
```c
const struct aws_http_headers *aws_http_message_get_const_headers(const struct aws_http_message *message);
```
"""
function aws_http_message_get_const_headers(message)
    ccall((:aws_http_message_get_const_headers, libaws_c_http), Ptr{aws_http_headers}, (Ptr{aws_http_message},), message)
end

"""
    aws_http_message_get_header_count(message)

Get the number of headers.

### Prototype
```c
size_t aws_http_message_get_header_count(const struct aws_http_message *message);
```
"""
function aws_http_message_get_header_count(message)
    ccall((:aws_http_message_get_header_count, libaws_c_http), Csize_t, (Ptr{aws_http_message},), message)
end

"""
    aws_http_message_get_header(message, out_header, index)

Get the header at the specified index. This function cannot fail if a valid index is provided. Otherwise, AWS\\_ERROR\\_INVALID\\_INDEX will be raised.

The underlying strings are stored within the message.

### Prototype
```c
int aws_http_message_get_header( const struct aws_http_message *message, struct aws_http_header *out_header, size_t index);
```
"""
function aws_http_message_get_header(message, out_header, index)
    ccall((:aws_http_message_get_header, libaws_c_http), Cint, (Ptr{aws_http_message}, Ptr{aws_http_header}, Csize_t), message, out_header, index)
end

"""
    aws_http_message_add_header(message, header)

Add a header to the end of the array. The message makes its own copy of the underlying strings.

### Prototype
```c
int aws_http_message_add_header(struct aws_http_message *message, struct aws_http_header header);
```
"""
function aws_http_message_add_header(message, header)
    ccall((:aws_http_message_add_header, libaws_c_http), Cint, (Ptr{aws_http_message}, aws_http_header), message, header)
end

"""
    aws_http_message_add_header_array(message, headers, num_headers)

Add an array of headers to the end of the header array. The message makes its own copy of the underlying strings.

This is a helper function useful when it's easier to define headers as a stack array, rather than calling add\\_header repeatedly.

### Prototype
```c
int aws_http_message_add_header_array( struct aws_http_message *message, const struct aws_http_header *headers, size_t num_headers);
```
"""
function aws_http_message_add_header_array(message, headers, num_headers)
    ccall((:aws_http_message_add_header_array, libaws_c_http), Cint, (Ptr{aws_http_message}, Ptr{aws_http_header}, Csize_t), message, headers, num_headers)
end

"""
    aws_http_message_erase_header(message, index)

Remove the header at the specified index. Headers after this index are all shifted back one position.

This function cannot fail if a valid index is provided. Otherwise, AWS\\_ERROR\\_INVALID\\_INDEX will be raised.

### Prototype
```c
int aws_http_message_erase_header(struct aws_http_message *message, size_t index);
```
"""
function aws_http_message_erase_header(message, index)
    ccall((:aws_http_message_erase_header, libaws_c_http), Cint, (Ptr{aws_http_message}, Csize_t), message, index)
end

"""
    aws_http_connection_make_request(client_connection, options)

Create a stream, with a client connection sending a request. The request does not start sending automatically once the stream is created. You must call [`aws_http_stream_activate`](@ref) to begin execution of the request.

The `options` are copied during this call.

Tip for language bindings: Do not bind the `options` struct. Use something more natural for your language, such as Builder Pattern in Java, or Python's ability to take many optional arguments by name.

Note: The header of the request will be sent as it is when the message to send protocol matches the protocol of the connection. - No `user-agent` will be added. - No security check will be enforced. eg: `referer` header privacy should be enforced by the user-agent who adds the header - When HTTP/1 message sent on HTTP/2 connection, [`aws_http2_message_new_from_http1`](@ref) will be applied under the hood. - When HTTP/2 message sent on HTTP/1 connection, no change will be made.

### Prototype
```c
struct aws_http_stream *aws_http_connection_make_request( struct aws_http_connection *client_connection, const struct aws_http_make_request_options *options);
```
"""
function aws_http_connection_make_request(client_connection, options)
    ccall((:aws_http_connection_make_request, libaws_c_http), Ptr{aws_http_stream}, (Ptr{aws_http_connection}, Ptr{aws_http_make_request_options}), client_connection, options)
end

"""
    aws_http_stream_new_server_request_handler(options)

Create a stream, with a server connection receiving and responding to a request. This function can only be called from the [`aws_http_on_incoming_request_fn`](@ref) callback. [`aws_http_stream_send_response`](@ref)() should be used to send a response.

### Prototype
```c
struct aws_http_stream *aws_http_stream_new_server_request_handler( const struct aws_http_request_handler_options *options);
```
"""
function aws_http_stream_new_server_request_handler(options)
    ccall((:aws_http_stream_new_server_request_handler, libaws_c_http), Ptr{aws_http_stream}, (Ptr{aws_http_request_handler_options},), options)
end

"""
    aws_http_stream_acquire(stream)

Acquire refcount on the stream to prevent it from being cleaned up until it is released.

### Prototype
```c
struct aws_http_stream *aws_http_stream_acquire(struct aws_http_stream *stream);
```
"""
function aws_http_stream_acquire(stream)
    ccall((:aws_http_stream_acquire, libaws_c_http), Ptr{aws_http_stream}, (Ptr{aws_http_stream},), stream)
end

"""
    aws_http_stream_release(stream)

Users must release the stream when they are done with it, or its memory will never be cleaned up. This will not cancel the stream, its callbacks will still fire if the stream is still in progress.

Tips for language bindings: - Invoke this from the wrapper class's finalizer/destructor. - Do not let the wrapper class be destroyed until on\\_complete() has fired.

### Prototype
```c
void aws_http_stream_release(struct aws_http_stream *stream);
```
"""
function aws_http_stream_release(stream)
    ccall((:aws_http_stream_release, libaws_c_http), Cvoid, (Ptr{aws_http_stream},), stream)
end

"""
    aws_http_stream_activate(stream)

Only used for client initiated streams (immediately following a call to [`aws_http_connection_make_request`](@ref)).

Activates the request's outgoing stream processing.

### Prototype
```c
int aws_http_stream_activate(struct aws_http_stream *stream);
```
"""
function aws_http_stream_activate(stream)
    ccall((:aws_http_stream_activate, libaws_c_http), Cint, (Ptr{aws_http_stream},), stream)
end

"""
    aws_http_stream_get_connection(stream)

Documentation not found.
### Prototype
```c
struct aws_http_connection *aws_http_stream_get_connection(const struct aws_http_stream *stream);
```
"""
function aws_http_stream_get_connection(stream)
    ccall((:aws_http_stream_get_connection, libaws_c_http), Ptr{aws_http_connection}, (Ptr{aws_http_stream},), stream)
end

"""
    aws_http_stream_get_incoming_response_status(stream, out_status)

Documentation not found.
### Prototype
```c
int aws_http_stream_get_incoming_response_status(const struct aws_http_stream *stream, int *out_status);
```
"""
function aws_http_stream_get_incoming_response_status(stream, out_status)
    ccall((:aws_http_stream_get_incoming_response_status, libaws_c_http), Cint, (Ptr{aws_http_stream}, Ptr{Cint}), stream, out_status)
end

"""
    aws_http_stream_get_incoming_request_method(stream, out_method)

Documentation not found.
### Prototype
```c
int aws_http_stream_get_incoming_request_method( const struct aws_http_stream *stream, struct aws_byte_cursor *out_method);
```
"""
function aws_http_stream_get_incoming_request_method(stream, out_method)
    ccall((:aws_http_stream_get_incoming_request_method, libaws_c_http), Cint, (Ptr{aws_http_stream}, Ptr{aws_byte_cursor}), stream, out_method)
end

"""
    aws_http_stream_get_incoming_request_uri(stream, out_uri)

Documentation not found.
### Prototype
```c
int aws_http_stream_get_incoming_request_uri(const struct aws_http_stream *stream, struct aws_byte_cursor *out_uri);
```
"""
function aws_http_stream_get_incoming_request_uri(stream, out_uri)
    ccall((:aws_http_stream_get_incoming_request_uri, libaws_c_http), Cint, (Ptr{aws_http_stream}, Ptr{aws_byte_cursor}), stream, out_uri)
end

"""
    aws_http_stream_send_response(stream, response)

Send response (only callable from "request handler" streams) The response object must stay alive at least until the stream's on\\_complete is called.

### Prototype
```c
int aws_http_stream_send_response(struct aws_http_stream *stream, struct aws_http_message *response);
```
"""
function aws_http_stream_send_response(stream, response)
    ccall((:aws_http_stream_send_response, libaws_c_http), Cint, (Ptr{aws_http_stream}, Ptr{aws_http_message}), stream, response)
end

"""
    aws_http_stream_update_window(stream, increment_size)

Increment the stream's flow-control window to keep data flowing.

If the connection was created with `manual_window_management` set true, the flow-control window of each stream will shrink as body data is received (headers, padding, and other metadata do not affect the window). The connection's `initial_window_size` determines the starting size of each stream's window. If a stream's flow-control window reaches 0, no further data will be received.

If `manual_window_management` is false, this call will have no effect. The connection maintains its flow-control windows such that no back-pressure is applied and data arrives as fast as possible.

For HTTP/2, the client control exactly when the WINDOW\\_UPDATE frame sent. And client will make sure the WINDOW\\_UPDATE frame to be valid. Check `stream_window_size_threshold_to_send_update` for details.

### Prototype
```c
void aws_http_stream_update_window(struct aws_http_stream *stream, size_t increment_size);
```
"""
function aws_http_stream_update_window(stream, increment_size)
    ccall((:aws_http_stream_update_window, libaws_c_http), Cvoid, (Ptr{aws_http_stream}, Csize_t), stream, increment_size)
end

"""
    aws_http_stream_get_id(stream)

Gets the HTTP/2 id associated with a stream. Even h1 streams have an id (using the same allocation procedure as http/2) for easier tracking purposes. For client streams, this will only be non-zero after a successful call to [`aws_http_stream_activate`](@ref)()

### Prototype
```c
uint32_t aws_http_stream_get_id(const struct aws_http_stream *stream);
```
"""
function aws_http_stream_get_id(stream)
    ccall((:aws_http_stream_get_id, libaws_c_http), UInt32, (Ptr{aws_http_stream},), stream)
end

"""
    aws_http_stream_cancel(stream, error_code)

Cancel the stream in flight. For HTTP/1.1 streams, it's equivalent to closing the connection. For HTTP/2 streams, it's equivalent to calling reset on the stream with `AWS_HTTP2_ERR_CANCEL`.

the stream will complete with the error code provided, unless the stream is already completing for other reasons, or the stream is not activated, in which case this call will have no impact.

### Prototype
```c
void aws_http_stream_cancel(struct aws_http_stream *stream, int error_code);
```
"""
function aws_http_stream_cancel(stream, error_code)
    ccall((:aws_http_stream_cancel, libaws_c_http), Cvoid, (Ptr{aws_http_stream}, Cint), stream, error_code)
end

"""
    aws_http2_stream_reset(http2_stream, http2_error)

Reset the HTTP/2 stream (HTTP/2 only). Note that if the stream closes before this async call is fully processed, the RST\\_STREAM frame will not be sent.

# Arguments
* `http2_stream`: HTTP/2 stream.
* `http2_error`: [`aws_http2_error_code`](@ref). Reason to reset the stream.
### Prototype
```c
int aws_http2_stream_reset(struct aws_http_stream *http2_stream, uint32_t http2_error);
```
"""
function aws_http2_stream_reset(http2_stream, http2_error)
    ccall((:aws_http2_stream_reset, libaws_c_http), Cint, (Ptr{aws_http_stream}, UInt32), http2_stream, http2_error)
end

"""
    aws_http2_stream_get_received_reset_error_code(http2_stream, out_http2_error)

Get the error code received in rst\\_stream. Only valid if the stream has completed, and an RST\\_STREAM frame has received.

# Arguments
* `http2_stream`: HTTP/2 stream.
* `out_http2_error`: Gets to set to HTTP/2 error code received in rst\\_stream.
### Prototype
```c
int aws_http2_stream_get_received_reset_error_code(struct aws_http_stream *http2_stream, uint32_t *out_http2_error);
```
"""
function aws_http2_stream_get_received_reset_error_code(http2_stream, out_http2_error)
    ccall((:aws_http2_stream_get_received_reset_error_code, libaws_c_http), Cint, (Ptr{aws_http_stream}, Ptr{UInt32}), http2_stream, out_http2_error)
end

"""
    aws_http2_stream_get_sent_reset_error_code(http2_stream, out_http2_error)

Get the HTTP/2 error code sent in the RST\\_STREAM frame (HTTP/2 only). Only valid if the stream has completed, and has sent an RST\\_STREAM frame.

# Arguments
* `http2_stream`: HTTP/2 stream.
* `out_http2_error`: Gets to set to HTTP/2 error code sent in rst\\_stream.
### Prototype
```c
int aws_http2_stream_get_sent_reset_error_code(struct aws_http_stream *http2_stream, uint32_t *out_http2_error);
```
"""
function aws_http2_stream_get_sent_reset_error_code(http2_stream, out_http2_error)
    ccall((:aws_http2_stream_get_sent_reset_error_code, libaws_c_http), Cint, (Ptr{aws_http_stream}, Ptr{UInt32}), http2_stream, out_http2_error)
end

"""
A listening socket which accepts incoming HTTP connections, creating a server-side [`aws_http_connection`](@ref) to handle each one.
"""
mutable struct aws_http_server end

# typedef void ( aws_http_server_on_incoming_connection_fn ) ( struct aws_http_server * server , struct aws_http_connection * connection , int error_code , void * user_data )
"""
Documentation not found.
"""
const aws_http_server_on_incoming_connection_fn = Cvoid

# typedef void ( aws_http_server_on_destroy_fn ) ( void * user_data )
"""
Documentation not found.
"""
const aws_http_server_on_destroy_fn = Cvoid

"""
    aws_http_server_options

Options for creating an HTTP server. Initialize with `AWS_HTTP_SERVER_OPTIONS_INIT` to set default values.
"""
struct aws_http_server_options
    self_size::Csize_t
    allocator::Ptr{aws_allocator}
    bootstrap::Ptr{aws_server_bootstrap}
    endpoint::Ptr{aws_socket_endpoint}
    socket_options::Ptr{aws_socket_options}
    tls_options::Ptr{aws_tls_connection_options}
    initial_window_size::Csize_t
    server_user_data::Ptr{Cvoid}
    on_incoming_connection::Ptr{aws_http_server_on_incoming_connection_fn}
    on_destroy_complete::Ptr{aws_http_server_on_destroy_fn}
    manual_window_management::Bool
end

# typedef struct aws_http_stream * ( aws_http_on_incoming_request_fn ) ( struct aws_http_connection * connection , void * user_data )
"""
Invoked at the start of an incoming request. To process the request, the user must create a request handler stream and return it to the connection. If NULL is returned, the request will not be processed and the last error will be reported as the reason for failure.
"""
const aws_http_on_incoming_request_fn = Cvoid

# typedef void ( aws_http_on_server_connection_shutdown_fn ) ( struct aws_http_connection * connection , int error_code , void * connection_user_data )
"""
Documentation not found.
"""
const aws_http_on_server_connection_shutdown_fn = Cvoid

"""
    aws_http_server_connection_options

Options for configuring a server-side [`aws_http_connection`](@ref). Initialized with `AWS_HTTP_SERVER_CONNECTION_OPTIONS_INIT` to set default values.
"""
struct aws_http_server_connection_options
    self_size::Csize_t
    connection_user_data::Ptr{Cvoid}
    on_incoming_request::Ptr{aws_http_on_incoming_request_fn}
    on_shutdown::Ptr{aws_http_on_server_connection_shutdown_fn}
end

"""
    aws_http_server_new(options)

Create server, a listening socket that accepts incoming connections.

### Prototype
```c
struct aws_http_server *aws_http_server_new(const struct aws_http_server_options *options);
```
"""
function aws_http_server_new(options)
    ccall((:aws_http_server_new, libaws_c_http), Ptr{aws_http_server}, (Ptr{aws_http_server_options},), options)
end

"""
    aws_http_server_release(server)

Release the server. It will close the listening socket and all the connections existing in the server. The on\\_destroy\\_complete will be invoked when the destroy operation completes

### Prototype
```c
void aws_http_server_release(struct aws_http_server *server);
```
"""
function aws_http_server_release(server)
    ccall((:aws_http_server_release, libaws_c_http), Cvoid, (Ptr{aws_http_server},), server)
end

"""
    aws_http_connection_configure_server(connection, options)

Configure a server connection. This must be called from the server's on\\_incoming\\_connection callback.

### Prototype
```c
int aws_http_connection_configure_server( struct aws_http_connection *connection, const struct aws_http_server_connection_options *options);
```
"""
function aws_http_connection_configure_server(connection, options)
    ccall((:aws_http_connection_configure_server, libaws_c_http), Cint, (Ptr{aws_http_connection}, Ptr{aws_http_server_connection_options}), connection, options)
end

"""
    aws_http_connection_is_server(connection)

Returns true if this is a server connection.

### Prototype
```c
bool aws_http_connection_is_server(const struct aws_http_connection *connection);
```
"""
function aws_http_connection_is_server(connection)
    ccall((:aws_http_connection_is_server, libaws_c_http), Bool, (Ptr{aws_http_connection},), connection)
end

"""
    aws_http_server_get_listener_endpoint(server)

Returns the local listener endpoint of the HTTP server. Only valid as long as the server remains valid.

### Prototype
```c
const struct aws_socket_endpoint *aws_http_server_get_listener_endpoint(const struct aws_http_server *server);
```
"""
function aws_http_server_get_listener_endpoint(server)
    ccall((:aws_http_server_get_listener_endpoint, libaws_c_http), Ptr{aws_socket_endpoint}, (Ptr{aws_http_server},), server)
end

"""
    aws_crt_http_statistics_category

Documentation not found.
"""
@cenum aws_crt_http_statistics_category::UInt32 begin
    AWSCRT_STAT_CAT_HTTP1_CHANNEL = 512
    AWSCRT_STAT_CAT_HTTP2_CHANNEL = 513
end

"""
    aws_crt_statistics_http1_channel

A statistics struct for http handlers. Tracks the actual amount of time that incoming and outgoing requests are waiting for their IO to complete.
"""
struct aws_crt_statistics_http1_channel
    category::aws_crt_statistics_category_t
    pending_outgoing_stream_ms::UInt64
    pending_incoming_stream_ms::UInt64
    current_outgoing_stream_id::UInt32
    current_incoming_stream_id::UInt32
end

"""
    aws_crt_statistics_http2_channel

Documentation not found.
"""
struct aws_crt_statistics_http2_channel
    category::aws_crt_statistics_category_t
    pending_outgoing_stream_ms::UInt64
    pending_incoming_stream_ms::UInt64
    was_inactive::Bool
end

"""
    aws_crt_statistics_http1_channel_init(stats)

Initializes a http channel handler statistics struct

### Prototype
```c
int aws_crt_statistics_http1_channel_init(struct aws_crt_statistics_http1_channel *stats);
```
"""
function aws_crt_statistics_http1_channel_init(stats)
    ccall((:aws_crt_statistics_http1_channel_init, libaws_c_http), Cint, (Ptr{aws_crt_statistics_http1_channel},), stats)
end

"""
    aws_crt_statistics_http1_channel_cleanup(stats)

Cleans up a http channel handler statistics struct

### Prototype
```c
void aws_crt_statistics_http1_channel_cleanup(struct aws_crt_statistics_http1_channel *stats);
```
"""
function aws_crt_statistics_http1_channel_cleanup(stats)
    ccall((:aws_crt_statistics_http1_channel_cleanup, libaws_c_http), Cvoid, (Ptr{aws_crt_statistics_http1_channel},), stats)
end

"""
    aws_crt_statistics_http1_channel_reset(stats)

Resets a http channel handler statistics struct's statistics

### Prototype
```c
void aws_crt_statistics_http1_channel_reset(struct aws_crt_statistics_http1_channel *stats);
```
"""
function aws_crt_statistics_http1_channel_reset(stats)
    ccall((:aws_crt_statistics_http1_channel_reset, libaws_c_http), Cvoid, (Ptr{aws_crt_statistics_http1_channel},), stats)
end

"""
    aws_crt_statistics_http2_channel_init(stats)

Initializes a HTTP/2 channel handler statistics struct

### Prototype
```c
void aws_crt_statistics_http2_channel_init(struct aws_crt_statistics_http2_channel *stats);
```
"""
function aws_crt_statistics_http2_channel_init(stats)
    ccall((:aws_crt_statistics_http2_channel_init, libaws_c_http), Cvoid, (Ptr{aws_crt_statistics_http2_channel},), stats)
end

"""
    aws_crt_statistics_http2_channel_reset(stats)

Resets a HTTP/2 channel handler statistics struct's statistics

### Prototype
```c
void aws_crt_statistics_http2_channel_reset(struct aws_crt_statistics_http2_channel *stats);
```
"""
function aws_crt_statistics_http2_channel_reset(stats)
    ccall((:aws_crt_statistics_http2_channel_reset, libaws_c_http), Cvoid, (Ptr{aws_crt_statistics_http2_channel},), stats)
end

"""
    aws_http_status_code

Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved. SPDX-License-Identifier: Apache-2.0.
"""
@cenum aws_http_status_code::Int32 begin
    AWS_HTTP_STATUS_CODE_UNKNOWN = -1
    AWS_HTTP_STATUS_CODE_100_CONTINUE = 100
    AWS_HTTP_STATUS_CODE_101_SWITCHING_PROTOCOLS = 101
    AWS_HTTP_STATUS_CODE_102_PROCESSING = 102
    AWS_HTTP_STATUS_CODE_103_EARLY_HINTS = 103
    AWS_HTTP_STATUS_CODE_200_OK = 200
    AWS_HTTP_STATUS_CODE_201_CREATED = 201
    AWS_HTTP_STATUS_CODE_202_ACCEPTED = 202
    AWS_HTTP_STATUS_CODE_203_NON_AUTHORITATIVE_INFORMATION = 203
    AWS_HTTP_STATUS_CODE_204_NO_CONTENT = 204
    AWS_HTTP_STATUS_CODE_205_RESET_CONTENT = 205
    AWS_HTTP_STATUS_CODE_206_PARTIAL_CONTENT = 206
    AWS_HTTP_STATUS_CODE_207_MULTI_STATUS = 207
    AWS_HTTP_STATUS_CODE_208_ALREADY_REPORTED = 208
    AWS_HTTP_STATUS_CODE_226_IM_USED = 226
    AWS_HTTP_STATUS_CODE_300_MULTIPLE_CHOICES = 300
    AWS_HTTP_STATUS_CODE_301_MOVED_PERMANENTLY = 301
    AWS_HTTP_STATUS_CODE_302_FOUND = 302
    AWS_HTTP_STATUS_CODE_303_SEE_OTHER = 303
    AWS_HTTP_STATUS_CODE_304_NOT_MODIFIED = 304
    AWS_HTTP_STATUS_CODE_305_USE_PROXY = 305
    AWS_HTTP_STATUS_CODE_307_TEMPORARY_REDIRECT = 307
    AWS_HTTP_STATUS_CODE_308_PERMANENT_REDIRECT = 308
    AWS_HTTP_STATUS_CODE_400_BAD_REQUEST = 400
    AWS_HTTP_STATUS_CODE_401_UNAUTHORIZED = 401
    AWS_HTTP_STATUS_CODE_402_PAYMENT_REQUIRED = 402
    AWS_HTTP_STATUS_CODE_403_FORBIDDEN = 403
    AWS_HTTP_STATUS_CODE_404_NOT_FOUND = 404
    AWS_HTTP_STATUS_CODE_405_METHOD_NOT_ALLOWED = 405
    AWS_HTTP_STATUS_CODE_406_NOT_ACCEPTABLE = 406
    AWS_HTTP_STATUS_CODE_407_PROXY_AUTHENTICATION_REQUIRED = 407
    AWS_HTTP_STATUS_CODE_408_REQUEST_TIMEOUT = 408
    AWS_HTTP_STATUS_CODE_409_CONFLICT = 409
    AWS_HTTP_STATUS_CODE_410_GONE = 410
    AWS_HTTP_STATUS_CODE_411_LENGTH_REQUIRED = 411
    AWS_HTTP_STATUS_CODE_412_PRECONDITION_FAILED = 412
    AWS_HTTP_STATUS_CODE_413_REQUEST_ENTITY_TOO_LARGE = 413
    AWS_HTTP_STATUS_CODE_414_REQUEST_URI_TOO_LONG = 414
    AWS_HTTP_STATUS_CODE_415_UNSUPPORTED_MEDIA_TYPE = 415
    AWS_HTTP_STATUS_CODE_416_REQUESTED_RANGE_NOT_SATISFIABLE = 416
    AWS_HTTP_STATUS_CODE_417_EXPECTATION_FAILED = 417
    AWS_HTTP_STATUS_CODE_421_MISDIRECTED_REQUEST = 421
    AWS_HTTP_STATUS_CODE_422_UNPROCESSABLE_ENTITY = 422
    AWS_HTTP_STATUS_CODE_423_LOCKED = 423
    AWS_HTTP_STATUS_CODE_424_FAILED_DEPENDENCY = 424
    AWS_HTTP_STATUS_CODE_425_TOO_EARLY = 425
    AWS_HTTP_STATUS_CODE_426_UPGRADE_REQUIRED = 426
    AWS_HTTP_STATUS_CODE_428_PRECONDITION_REQUIRED = 428
    AWS_HTTP_STATUS_CODE_429_TOO_MANY_REQUESTS = 429
    AWS_HTTP_STATUS_CODE_431_REQUEST_HEADER_FIELDS_TOO_LARGE = 431
    AWS_HTTP_STATUS_CODE_451_UNAVAILABLE_FOR_LEGAL_REASON = 451
    AWS_HTTP_STATUS_CODE_500_INTERNAL_SERVER_ERROR = 500
    AWS_HTTP_STATUS_CODE_501_NOT_IMPLEMENTED = 501
    AWS_HTTP_STATUS_CODE_502_BAD_GATEWAY = 502
    AWS_HTTP_STATUS_CODE_503_SERVICE_UNAVAILABLE = 503
    AWS_HTTP_STATUS_CODE_504_GATEWAY_TIMEOUT = 504
    AWS_HTTP_STATUS_CODE_505_HTTP_VERSION_NOT_SUPPORTED = 505
    AWS_HTTP_STATUS_CODE_506_VARIANT_ALSO_NEGOTIATES = 506
    AWS_HTTP_STATUS_CODE_507_INSUFFICIENT_STORAGE = 507
    AWS_HTTP_STATUS_CODE_508_LOOP_DETECTED = 508
    AWS_HTTP_STATUS_CODE_510_NOT_EXTENDED = 510
    AWS_HTTP_STATUS_CODE_511_NETWORK_AUTHENTICATION_REQUIRED = 511
end

"""
    aws_websocket_opcode

Opcode describing the type of a websocket frame. RFC-6455 Section 5.2
"""
@cenum aws_websocket_opcode::UInt32 begin
    AWS_WEBSOCKET_OPCODE_CONTINUATION = 0
    AWS_WEBSOCKET_OPCODE_TEXT = 1
    AWS_WEBSOCKET_OPCODE_BINARY = 2
    AWS_WEBSOCKET_OPCODE_CLOSE = 8
    AWS_WEBSOCKET_OPCODE_PING = 9
    AWS_WEBSOCKET_OPCODE_PONG = 10
end

"""
A websocket connection.
"""
mutable struct aws_websocket end

"""
    aws_websocket_on_connection_setup_data

Data passed to the websocket on\\_connection\\_setup callback.

An error\\_code of zero indicates that setup was completely successful. You own the websocket pointer now and must call [`aws_websocket_release`](@ref)() when you are done with it. You can inspect the response headers, if you're interested.

A non-zero error\\_code indicates that setup failed. The websocket pointer will be NULL. If the server sent a response, you can inspect its status-code, headers, and body, but this data will NULL if setup failed before a full response could be received. If you wish to persist data from the response make a deep copy. The response data becomes invalid once the callback completes.
"""
struct aws_websocket_on_connection_setup_data
    error_code::Cint
    websocket::Ptr{aws_websocket}
    handshake_response_status::Ptr{Cint}
    handshake_response_header_array::Ptr{aws_http_header}
    num_handshake_response_headers::Csize_t
    handshake_response_body::Ptr{aws_byte_cursor}
end

# typedef void ( aws_websocket_on_connection_setup_fn ) ( const struct aws_websocket_on_connection_setup_data * setup , void * user_data )
"""
Called when websocket setup is complete. Called exactly once on the websocket's event-loop thread. See [`aws_websocket_on_connection_setup_data`](@ref).
"""
const aws_websocket_on_connection_setup_fn = Cvoid

# typedef void ( aws_websocket_on_connection_shutdown_fn ) ( struct aws_websocket * websocket , int error_code , void * user_data )
"""
Called when the websocket has finished shutting down. Called once on the websocket's event-loop thread if setup succeeded. If setup failed, this is never called.
"""
const aws_websocket_on_connection_shutdown_fn = Cvoid

"""
    aws_websocket_incoming_frame

Data about an incoming frame. See RFC-6455 Section 5.2.
"""
struct aws_websocket_incoming_frame
    payload_length::UInt64
    opcode::UInt8
    fin::Bool
end

# typedef bool ( aws_websocket_on_incoming_frame_begin_fn ) ( struct aws_websocket * websocket , const struct aws_websocket_incoming_frame * frame , void * user_data )
"""
Called when a new frame arrives. Invoked once per frame on the websocket's event-loop thread. Each incoming-frame-begin call will eventually be followed by an incoming-frame-complete call, before the next frame begins and before the websocket shuts down.

Return true to proceed normally. If false is returned, the websocket will read no further data, the frame will complete with an error-code, and the connection will close.
"""
const aws_websocket_on_incoming_frame_begin_fn = Cvoid

# typedef bool ( aws_websocket_on_incoming_frame_payload_fn ) ( struct aws_websocket * websocket , const struct aws_websocket_incoming_frame * frame , struct aws_byte_cursor data , void * user_data )
"""
Called repeatedly as payload data arrives. Invoked 0 or more times on the websocket's event-loop thread. Payload data will not be valid after this call, so copy if necessary. The payload data is always unmasked at this point.

NOTE: If you created the websocket with `manual_window_management` set true, you must maintain the read window. Whenever the read window reaches 0, you will stop receiving anything. The websocket's `initial_window_size` determines the starting size of the read window. The read window shrinks as you receive the payload from "data" frames (TEXT, BINARY, and CONTINUATION). Use [`aws_websocket_increment_read_window`](@ref)() to increment the window again and keep frames flowing. Maintain a larger window to keep up high throughput. You only need to worry about the payload from "data" frames. The websocket automatically increments the window to account for any other incoming bytes, including other parts of a frame (opcode, payload-length, etc) and the payload of other frame types (PING, PONG, CLOSE).

Return true to proceed normally. If false is returned, the websocket will read no further data, the frame will complete with an error-code, and the connection will close.
"""
const aws_websocket_on_incoming_frame_payload_fn = Cvoid

# typedef bool ( aws_websocket_on_incoming_frame_complete_fn ) ( struct aws_websocket * websocket , const struct aws_websocket_incoming_frame * frame , int error_code , void * user_data )
"""
Called when done processing an incoming frame. If error\\_code is non-zero, an error occurred and the payload may not have been completely received. Invoked once per frame on the websocket's event-loop thread.

Return true to proceed normally. If false is returned, the websocket will read no further data and the connection will close.
"""
const aws_websocket_on_incoming_frame_complete_fn = Cvoid

"""
    aws_websocket_client_connection_options

Options for creating a websocket client connection.
"""
struct aws_websocket_client_connection_options
    allocator::Ptr{aws_allocator}
    bootstrap::Ptr{aws_client_bootstrap}
    socket_options::Ptr{aws_socket_options}
    tls_options::Ptr{aws_tls_connection_options}
    proxy_options::Ptr{aws_http_proxy_options}
    host::aws_byte_cursor
    port::UInt32
    handshake_request::Ptr{aws_http_message}
    initial_window_size::Csize_t
    user_data::Ptr{Cvoid}
    on_connection_setup::Ptr{aws_websocket_on_connection_setup_fn}
    on_connection_shutdown::Ptr{aws_websocket_on_connection_shutdown_fn}
    on_incoming_frame_begin::Ptr{aws_websocket_on_incoming_frame_begin_fn}
    on_incoming_frame_payload::Ptr{aws_websocket_on_incoming_frame_payload_fn}
    on_incoming_frame_complete::Ptr{aws_websocket_on_incoming_frame_complete_fn}
    manual_window_management::Bool
    requested_event_loop::Ptr{aws_event_loop}
    host_resolution_config::Ptr{aws_host_resolution_config}
end

# typedef bool ( aws_websocket_stream_outgoing_payload_fn ) ( struct aws_websocket * websocket , struct aws_byte_buf * out_buf , void * user_data )
"""
Called repeatedly as the websocket's payload is streamed out. The user should write payload data to out\\_buf, up to available capacity. The websocket will mask this data for you, if necessary. Invoked repeatedly on the websocket's event-loop thread.

Return true to proceed normally. If false is returned, the websocket will send no further data, the frame will complete with an error-code, and the connection will close.
"""
const aws_websocket_stream_outgoing_payload_fn = Cvoid

# typedef void ( aws_websocket_outgoing_frame_complete_fn ) ( struct aws_websocket * websocket , int error_code , void * user_data )
"""
Called when a [`aws_websocket_send_frame`](@ref)() operation completes. error\\_code will be zero if the operation was successful. "Success" does not guarantee that the peer actually received or processed the frame. Invoked exactly once per sent frame on the websocket's event-loop thread.
"""
const aws_websocket_outgoing_frame_complete_fn = Cvoid

"""
    aws_websocket_send_frame_options

Options for sending a websocket frame. This structure is copied immediately by aws\\_websocket\\_send(). For descriptions of opcode, fin, and payload\\_length see in RFC-6455 Section 5.2.
"""
struct aws_websocket_send_frame_options
    payload_length::UInt64
    user_data::Ptr{Cvoid}
    stream_outgoing_payload::Ptr{aws_websocket_stream_outgoing_payload_fn}
    on_complete::Ptr{aws_websocket_outgoing_frame_complete_fn}
    opcode::UInt8
    fin::Bool
end

"""
    aws_websocket_is_data_frame(opcode)

Return true if opcode is for a data frame, false if opcode if for a control frame.

### Prototype
```c
bool aws_websocket_is_data_frame(uint8_t opcode);
```
"""
function aws_websocket_is_data_frame(opcode)
    ccall((:aws_websocket_is_data_frame, libaws_c_http), Bool, (UInt8,), opcode)
end

"""
    aws_websocket_client_connect(options)

Asynchronously establish a client websocket connection. The on\\_connection\\_setup callback is invoked when the operation has finished creating a connection, or failed.

### Prototype
```c
int aws_websocket_client_connect(const struct aws_websocket_client_connection_options *options);
```
"""
function aws_websocket_client_connect(options)
    ccall((:aws_websocket_client_connect, libaws_c_http), Cint, (Ptr{aws_websocket_client_connection_options},), options)
end

"""
    aws_websocket_acquire(websocket)

Increment the websocket's ref-count, preventing it from being destroyed.

# Returns
Always returns the same pointer that is passed in.
### Prototype
```c
struct aws_websocket *aws_websocket_acquire(struct aws_websocket *websocket);
```
"""
function aws_websocket_acquire(websocket)
    ccall((:aws_websocket_acquire, libaws_c_http), Ptr{aws_websocket}, (Ptr{aws_websocket},), websocket)
end

"""
    aws_websocket_release(websocket)

Decrement the websocket's ref-count. When the ref-count reaches zero, the connection will shut down, if it hasn't already. Users must release the websocket when they are done with it. The websocket's memory cannot be reclaimed until this is done. Callbacks may continue firing after this is called, with "shutdown" being the final callback. This function may be called from any thread.

It is safe to pass NULL, nothing will happen.

### Prototype
```c
void aws_websocket_release(struct aws_websocket *websocket);
```
"""
function aws_websocket_release(websocket)
    ccall((:aws_websocket_release, libaws_c_http), Cvoid, (Ptr{aws_websocket},), websocket)
end

"""
    aws_websocket_close(websocket, free_scarce_resources_immediately)

Close the websocket connection. It is safe to call this, even if the connection is already closed or closing. The websocket will attempt to send a CLOSE frame during normal shutdown. If `free_scarce_resources_immediately` is true, the connection will be torn down as quickly as possible. This function may be called from any thread.

### Prototype
```c
void aws_websocket_close(struct aws_websocket *websocket, bool free_scarce_resources_immediately);
```
"""
function aws_websocket_close(websocket, free_scarce_resources_immediately)
    ccall((:aws_websocket_close, libaws_c_http), Cvoid, (Ptr{aws_websocket}, Bool), websocket, free_scarce_resources_immediately)
end

"""
    aws_websocket_send_frame(websocket, options)

Send a websocket frame. The `options` struct is copied. A callback will be invoked when the operation completes. This function may be called from any thread.

### Prototype
```c
int aws_websocket_send_frame(struct aws_websocket *websocket, const struct aws_websocket_send_frame_options *options);
```
"""
function aws_websocket_send_frame(websocket, options)
    ccall((:aws_websocket_send_frame, libaws_c_http), Cint, (Ptr{aws_websocket}, Ptr{aws_websocket_send_frame_options}), websocket, options)
end

"""
    aws_websocket_increment_read_window(websocket, size)

Manually increment the read window to keep frames flowing.

If the websocket was created with `manual_window_management` set true, then whenever the read window reaches 0 you will stop receiving data. The websocket's `initial_window_size` determines the starting size of the read window. The read window shrinks as you receive the payload from "data" frames (TEXT, BINARY, and CONTINUATION). Use [`aws_websocket_increment_read_window`](@ref)() to increment the window again and keep frames flowing. Maintain a larger window to keep up high throughput. You only need to worry about the payload from "data" frames. The websocket automatically increments the window to account for any other incoming bytes, including other parts of a frame (opcode, payload-length, etc) and the payload of other frame types (PING, PONG, CLOSE).

If the websocket was created with `manual_window_management` set false, this function does nothing.

This function may be called from any thread.

### Prototype
```c
void aws_websocket_increment_read_window(struct aws_websocket *websocket, size_t size);
```
"""
function aws_websocket_increment_read_window(websocket, size)
    ccall((:aws_websocket_increment_read_window, libaws_c_http), Cvoid, (Ptr{aws_websocket}, Csize_t), websocket, size)
end

"""
    aws_websocket_convert_to_midchannel_handler(websocket)

Convert the websocket into a mid-channel handler. The websocket will stop being usable via its public API and become just another handler in the channel. The caller will likely install a channel handler to the right. This must not be called in the middle of an incoming frame (between "frame begin" and "frame complete" callbacks). This MUST be called from the websocket's thread.

If successful: - Other than [`aws_websocket_release`](@ref)(), all calls to aws\\_websocket\\_x() functions are ignored. - The websocket will no longer invoke any "incoming frame" callbacks. - aws\\_io\\_messages written by a downstream handler will be wrapped in binary data frames and sent upstream. The data may be split/combined as it is sent along. - aws\\_io\\_messages read from upstream handlers will be scanned for binary data frames. The payloads of these frames will be sent downstream. The payloads may be split/combined as they are sent along. - An incoming close frame will automatically result in channel-shutdown. - [`aws_websocket_release`](@ref)() must still be called or the websocket and its channel will never be cleaned up. - The websocket will still invoke its "on connection shutdown" callback when channel shutdown completes.

If unsuccessful, NULL is returned and the websocket is unchanged.

### Prototype
```c
int aws_websocket_convert_to_midchannel_handler(struct aws_websocket *websocket);
```
"""
function aws_websocket_convert_to_midchannel_handler(websocket)
    ccall((:aws_websocket_convert_to_midchannel_handler, libaws_c_http), Cint, (Ptr{aws_websocket},), websocket)
end

"""
    aws_websocket_get_channel(websocket)

Returns the websocket's underlying I/O channel.

### Prototype
```c
struct aws_channel *aws_websocket_get_channel(const struct aws_websocket *websocket);
```
"""
function aws_websocket_get_channel(websocket)
    ccall((:aws_websocket_get_channel, libaws_c_http), Ptr{Cvoid}, (Ptr{aws_websocket},), websocket)
end

"""
    aws_websocket_random_handshake_key(dst)

Generate value for a Sec-WebSocket-Key header and write it into `dst` buffer. The buffer should have at least [`AWS_WEBSOCKET_MAX_HANDSHAKE_KEY_LENGTH`](@ref) space available.

This value is the base64 encoding of a random 16-byte value. RFC-6455 Section 4.1

### Prototype
```c
int aws_websocket_random_handshake_key(struct aws_byte_buf *dst);
```
"""
function aws_websocket_random_handshake_key(dst)
    ccall((:aws_websocket_random_handshake_key, libaws_c_http), Cint, (Ptr{Cvoid},), dst)
end

"""
    aws_http_message_new_websocket_handshake_request(allocator, path, host)

Create request with all required fields for a websocket upgrade request. The method and path are set, and the the following headers are added:

Host: <host> Upgrade: websocket Connection: Upgrade Sec-WebSocket-Key: <base64 encoding of 16 random bytes> Sec-WebSocket-Version: 13

### Prototype
```c
struct aws_http_message *aws_http_message_new_websocket_handshake_request( struct aws_allocator *allocator, struct aws_byte_cursor path, struct aws_byte_cursor host);
```
"""
function aws_http_message_new_websocket_handshake_request(allocator, path, host)
    ccall((:aws_http_message_new_websocket_handshake_request, libaws_c_http), Ptr{aws_http_message}, (Ptr{aws_allocator}, aws_byte_cursor, aws_byte_cursor), allocator, path, host)
end

"""
Documentation not found.
"""
const AWS_HTTP2_DEFAULT_MAX_CLOSED_STREAMS = 32

"""
Documentation not found.
"""
const AWS_HTTP2_PING_DATA_SIZE = 8

"""
Documentation not found.
"""
const AWS_HTTP2_SETTINGS_COUNT = 6

# Skipping MacroDefinition: AWS_HTTP_CLIENT_CONNECTION_OPTIONS_INIT { . self_size = sizeof ( struct aws_http_client_connection_options ) , . initial_window_size = SIZE_MAX , }

"""
Documentation not found.
"""
const AWS_C_HTTP_PACKAGE_ID = 2

# Skipping MacroDefinition: AWS_HTTP_REQUEST_HANDLER_OPTIONS_INIT { . self_size = sizeof ( struct aws_http_request_handler_options ) , }

# Skipping MacroDefinition: AWS_HTTP_SERVER_OPTIONS_INIT { . self_size = sizeof ( struct aws_http_server_options ) , . initial_window_size = SIZE_MAX , }

# Skipping MacroDefinition: AWS_HTTP_SERVER_CONNECTION_OPTIONS_INIT { . self_size = sizeof ( struct aws_http_server_connection_options ) , }

"""
Documentation not found.
"""
const AWS_WEBSOCKET_MAX_PAYLOAD_LENGTH = 0x7fffffffffffffff

"""
Documentation not found.
"""
const AWS_WEBSOCKET_MAX_HANDSHAKE_KEY_LENGTH = 25

"""
Documentation not found.
"""
const AWS_WEBSOCKET_CLOSE_TIMEOUT = 1000000000

