Config = {}
Config.Debug = false
Config.Model = 'a_m_m_fatlatin_01'
Config.PedCoords = vector4(1135.5521, -665.6054, 56.1, 95.2930)
Config.Blip = {title = "Zbierz cukierki", colour = 17, id = 40}

Config.Zones = {

    {
        {coords = vector4(996.8249, -729.6454, 57.8157, 134.9633)},
        {coords = vector4(979.1958, -716.2761, 58.2206, 133.8717)},
        {coords = vector4(970.8478, -701.1111, 58.4819, 174.3593)}
    }

}
Config.Peds = {
    'u_m_y_zombie_01', 'ig_trafficwarden', 'ig_prolsec_02',
    'u_m_y_juggernaut_01', 'u_m_y_mani', 'u_m_y_dancerave_01',
    'ig_chrisformage', 'ig_bride', 'u_m_o_filmnoir', 'a_f_m_fatcult_01',
    'a_m_m_afriamer_01', 'u_m_y_rsranger_01', 'a_m_y_smartcaspat_01',
    'ig_rashcosvki', 'u_f_o_eileen', 'ig_clay', 'u_f_y_dancerave_01',
    'u_m_m_streetart_01'

}

Config.TrickOrTreat = 'Cukierek albo psikus!'

Config.Locales = {
    questCompleted = 'Ukończono Zadanie!',
    questStarted = 'Benek : Domy masz zaznaczone na mapie. Wróc z pełnym wiaderkiem!',
    pukpuk = 'Zapukaj do drzwi',
    skipDialog = "Naciśnij ~g~[E]~w~, aby pominąć kwestie",
    startDialog = 'Porozmawiaj z Benkiem',
    returnToBenek = 'Oddaj Cukierki!'
}

Config.Dialog = {
    {
        desc = 'Cześć',
        animation = {
            lib = "friends@frj@ig_1",
            anim = "wave_c"
        }
    },
    {
        desc = 'Mam dla ciebie specjalne zadanie',
        animation = {}
    },
    {
        desc = 'Zebrałem już wszystkie cukierki a chce więcej',
        animation = {}
    }, 
    {
        desc = 'Pójdź do moich sąsiadów, pozbieraj cukierki i przyjdź z nimi do mnie po nagrodę!',
        animation = {lib = "mp_common", anim = "givetake1_a"}
    }
}

