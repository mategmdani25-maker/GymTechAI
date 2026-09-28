import math
from .schemas import AthleteConfig, CheckIn

def epley(weight: float, reps: int) -> float:
    return weight if reps <= 1 else round(weight * (1 + reps / 30), 1)

def round_bar(weight: float, step: float) -> float:
    return round(weight / step) * step

def plates(weight: float, bar: float = 20) -> str:
    if weight <= bar: return "Barra vacía"
    side = round((weight - bar) / 2, 2)
    result = []
    for plate in (25, 20, 15, 10, 5, 2.5, 1.25, .5):
        while side >= plate:
            result.append(f"{plate:g}kg")
            side = round(side - plate, 2)
    return " + ".join(result) + " por lado" if result else "Microajuste menor a 1.25kg"

def day(name="Descanso", note="Día libre"):
    return {"dia_nombre": name, "nota_general": note, "ejercicios": []}

def exercise(name, weight, strategy, step):
    return {"nombre": name, "peso_kg": weight, "estrategia": strategy, "discos_por_lado": plates(weight), "calentamiento": f"Aproximación hasta {round_bar(weight*.55, step)}kg"}

def generate_macrocycle(c: AthleteConfig):
    weeks = 12 if c.tipo_usuario == "gratis" else c.semanas_totales
    one_rm = {"snt": epley(c.rm_snt, c.reps_snt), "bnc": epley(c.rm_bnc, c.reps_bnc), "rdl": epley(c.rm_rdl, c.reps_rdl)}
    b1, b2 = math.ceil(weeks/3), math.ceil(weeks*2/3)
    output = {"semanas_totales": weeks, "1rm_estimados": one_rm, "semanas": []}
    for week in range(1, weeks + 1):
        if week <= b1:
            phase, pct, reps, label = "Acumulación", (0.60 if week == b1 else 0.65 + week/b1*.08), (4 if week == b1 else 8), "Volumen"
        elif week <= b2:
            phase, pct, reps, label = "Transmisión", (0.65 if week == b2 else 0.75 + ((week-b1)/(b2-b1))*.10), (5 if week == b2 else (4 if pct < .82 else 3)), "Fuerza"
        elif week == weeks:
            phase, pct, reps, label = "Test de récord", 1.05, 1, "PR day"
        elif week == weeks - 1:
            phase, pct, reps, label = "Activación", .95, 1, "Singles"
        else:
            phase, pct, reps, label = "Intensificación", (.875 if week == weeks-3 else .925), (3 if week == weeks-3 else 2), "Intensidad"
        squat = round_bar(one_rm["snt"]*pct, c.salto_minimo_barra); bench = round_bar(one_rm["bnc"]*pct, c.salto_minimo_barra); rdl = round_bar(one_rm["rdl"]*pct, c.salto_minimo_barra)
        strategy = f"Top set 1x{reps} + back-off 3x5" if label not in ("Volumen", "PR day") else (f"4x{reps} RPE 7" if label == "Volumen" else "Intentos 92%, 100% y PR")
        monday = day("Pierna - " + phase, "Control técnico y progresión segura")
        monday["ejercicios"] = [exercise(c.ej_snt, squat, strategy, c.salto_minimo_barra), exercise(c.ej_rdl, rdl, f"3x{10 if label == 'Volumen' else reps}", c.salto_minimo_barra)]
        wednesday = day("Torso - " + phase, "Recorrido completo y estabilidad")
        wednesday["ejercicios"] = [exercise(c.ej_bnc, bench, strategy, c.salto_minimo_barra)]
        tonelaje = round(squat*reps*4 + bench*reps*4 + rdl*10*3)
        output["semanas"].append({"semana": week, "fase": phase, "porcentaje": round(pct*100, 1), "tonelaje_kg": tonelaje, "lunes": monday, "miercoles": wednesday})
    return output

def autoregulate(c: CheckIn):
    factor, message = 1.0, "Estado óptimo: mantén la carga programada."
    if c.nivel_energia <= 2 or c.nivel_dolor >= 4 or c.estado_bio in {"estres_alto", "cansancio"}:
        factor, message = .88, "Fatiga detectada: deload inteligente del 12%."
    elif c.nivel_energia == 5 and c.nivel_dolor <= 1 and c.estado_bio in {"normal", "folicular"}:
        factor, message = 1.025, "Estado excelente: incremento opcional del 2.5%."
    adjusted = round_bar(c.peso_ejercicio_hoy * factor, c.salto_minimo)
    return {"mensaje": message, "peso_original_kg": c.peso_ejercicio_hoy, "peso_ajustado_kg": adjusted, "discos_por_lado": plates(adjusted)}
