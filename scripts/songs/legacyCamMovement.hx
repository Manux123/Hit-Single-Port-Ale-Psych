using StringTools;

var dadOffsetX:Float = 0;
var dadOffsetY:Float = 0;
var bfOffsetX:Float = 0;
var bfOffsetY:Float = 0;

var dadSingOffset:Float = 60;
var bfSingOffset:Float = 60;
var dadRotation:Float = 1.5;
var bfRotation:Float = 1.5;

var cameraEnabled:Bool = true;
var rotationEnabled:Bool = false;
var cameraMoving:Bool = false;

final CAMERA_LERP:Float = 0.2;
final ROTATION_LERP:Float = 0.2;

function postCreate()
{
    syncCamera(true);
}

function onEventHit(id:String, value1:Dynamic, value2:Dynamic)
{
    switch ((id == null ? '' : id.toLowerCase()))
    {
        case 'camofs':
            setPair(value1, value2, (dad, bf) -> {
                dadSingOffset = dad;
                bfSingOffset = bf;
            }, dadSingOffset, bfSingOffset);

        case 'mechi':
            if (value1 == null || Std.string(value1) == '')
                cameraEnabled = !cameraEnabled;
            else if (Std.string(value1).toLowerCase() == 'on')
                cameraEnabled = true;
            else if (Std.string(value1).toLowerCase() == 'off')
                cameraEnabled = false;

        case 'rotation':
            if (value1 == null || Std.string(value1) == '')
                rotationEnabled = !rotationEnabled;
            else if (Std.string(value1).toLowerCase() == 'on')
                rotationEnabled = true;
            else if (Std.string(value1).toLowerCase() == 'off')
                rotationEnabled = false;

        case 'ofisetidad':
            setPair(value1, value2, (x, y) -> {
                dadOffsetX = x;
                dadOffsetY = y;
            }, dadOffsetX, dadOffsetY);

            if (cameraEnabled)
                syncCamera(true);

        case 'ofisetibf':
            setPair(value1, value2, (x, y) -> {
                bfOffsetX = x;
                bfOffsetY = y;
            }, bfOffsetX, bfOffsetY);

            if (cameraEnabled)
                syncCamera(true);
    }
}

function onCameraMove(character)
{
    if (!cameraEnabled)
        return;

    syncCamera(true, character);
    return Function_Stop;
}

function onUpdate(elapsed:Float)
{
    if (!cameraEnabled)
    {
        if (rotationEnabled && Math.abs(game.camGame.angle) > 0.001)
            game.camGame.angle = CoolUtil.fpsLerp(game.camGame.angle, 0, ROTATION_LERP);
        return;
    }

    syncCamera(false, getCurrentCameraTarget());
}

function syncCamera(force:Bool, ?character)
{
    character ??= getCameraTarget();

    if (character == null)
        return;

    var isPlayer:Bool = character == game.boyfriend;
    var midpoint = character.getMidpoint();
    var camOffsetX:Float = getCameraOffset(character, true);
    var camOffsetY:Float = getCameraOffset(character, false);

    var x:Float = midpoint.x + camOffsetX * (character.type == 'player' ? -1 : 1);
    var y:Float = midpoint.y + camOffsetY;

    if (isPlayer)
    {
        x += bfOffsetX;
        y += bfOffsetY;
    }
    else
    {
        x += dadOffsetX;
        y += dadOffsetY;
    }

    var anim:String = getSingAnimation(character);
    var singOffset:Float = isPlayer ? bfSingOffset : dadSingOffset;
    var rotation:Float = isPlayer ? bfRotation : dadRotation;
    var angle:Float = 0;

    if (anim != null)
    {
        if (anim.startsWith('singleft'))
        {
            x -= singOffset;
            angle = rotation;
        }
        else if (anim.startsWith('singright'))
        {
            x += singOffset;
            angle = -rotation;
        }
        else if (anim.startsWith('singup'))
        {
            y -= singOffset;
        }
        else if (anim.startsWith('singdown'))
        {
            y += singOffset;
        }
    }
    else if (cameraMoving || force)
    {
        cameraMoving = false;
    }

    game.camGame.position.set(x, y);
    cameraMoving = anim != null;

    if (rotationEnabled)
        game.camGame.angle = CoolUtil.fpsLerp(game.camGame.angle, angle, CAMERA_LERP);
    else if (Math.abs(game.camGame.angle) > 0.001)
        game.camGame.angle = CoolUtil.fpsLerp(game.camGame.angle, 0, ROTATION_LERP);
}

function getCameraTarget()
{
    var section = game.CHART != null && game.curSection < game.CHART.sections.length ? game.CHART.sections[game.curSection] : null;

    if (section != null && section.gfSection && game.gf != null)
        return game.gf;

    if (section != null && section.mustHitSection)
        return game.boyfriend;

    return game.dad;
}

function getCurrentCameraTarget()
{
    var target = Reflect.field(game, 'cameraTarget');

    if (target != null)
        return target;

    return getCameraTarget();
}

function getSingAnimation(character):String
{
    if (character == null || character.animation == null || character.animation.curAnim == null)
        return null;

    return character.animation.curAnim.name == null ? null : character.animation.curAnim.name.toLowerCase();
}

function parseOrKeep(value:Dynamic, fallback:Float):Float
{
    var text:String = value == null ? '' : Std.string(value);

    if (text.trim() == '')
        return fallback;

    var parsed:Float = Std.parseFloat(text);
    return Math.isNaN(parsed) ? fallback : parsed;
}

function getCameraOffset(target, horizontal:Bool):Float
{
    if (target == null)
        return 0;

    var cfg:Dynamic = Reflect.field(target, 'config');
    var offset:Dynamic = cfg == null ? null : Reflect.field(cfg, 'cameraOffset');

    if (offset == null)
        return 0;

    var value:Dynamic = Reflect.field(offset, horizontal ? 'x' : 'y');
    return value == null ? 0 : value;
}

function setPair(value1:Dynamic, value2:Dynamic, apply:Float -> Float -> Void, fallback1:Float, fallback2:Float)
{
    apply(parseOrKeep(value1, fallback1), parseOrKeep(value2, fallback2));
}
