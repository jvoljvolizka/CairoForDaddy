%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256
from starkware.starknet.common.syscalls import get_caller_address
from starkware.cairo.common.math import assert_not_zero

@storage_var
func Daddy() -> (daddy : felt):
end

@storage_var
func Target() -> (target : Uint256):
end

@storage_var
func Tries() -> (tries : Uint256):
end

@storage_var
func Player() -> (player : felt):
end

@constructor
func constructor{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        daddy : felt, player : felt):
    Daddy.write(daddy)
    Player.write(player)
    return ()
end

func start{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        target : Uint256, tries : Uint256):
    let (caller) = get_caller_address()
    let (daddy) = Daddy.read()
    assert_not_zero(caller)
    assert_not_zero(target)
    assert_not_zero(tries)
    with_attr error_message("Hey you are not my daddy! >_<"):
        assert caller = daddy
    end
    Target.write(target)
    Tries.write(tries)
    return ()
end

func disown{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(player : felt):
    let (caller) = get_caller_address()
    let (daddy) = Daddy.read()
    with_attr error_message("Hey you are not my daddy! >_<"):
        assert caller = daddy
    end
    Player.write(player)
    return ()
end

func newDaddy{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(newdaddy : felt):
    let (caller) = get_caller_address()
    let (daddy) = Daddy.read()
    with_attr error_message("Hey you are not my daddy! >_<"):
        assert caller = daddy
    end
    Daddy.write(newdaddy)
    return ()
end

func guess{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        guessednum : Uint256) -> (res : felt):
    let (caller) = get_caller_address()
    let (player) = Player.read()
    let (tries) = Tries.read()
    let (target) = Target.read()
    with_attr error_message("Who the fuck are you ?"):
        assert caller = player
    end
    let (is_zero) = uint256_eq(tries, Uint256(0, 0))

    with_attr error_message("You lost already"):
        assert_zero(is_zero)
    end
    let (is_eq) = uint256_eq(guessednum, target)
    if is_eq == 1:
        return (res=1)
    end
    uint256_sub(target, Uint(1, 0))
    return (res=0)
end
