#!/usr/bin/env python3
import calendar
import datetime
import json
import zoneinfo


def main():
    now_local = datetime.datetime.now()
    now_utc = datetime.datetime.now(datetime.timezone.utc)

    bar_text = now_local.strftime("%d-%m-%y | %I:%M %p")

    year, month, today_day = now_local.year, now_local.month, now_local.day
    cal = calendar.Calendar(firstweekday=6)

    month_name = now_local.strftime("%B %Y")
    cal_lines = [f"<b>{month_name:^43}</b>\n"]

    cell_w = 5
    dim = "<span color='#383c44'>"
    dim_end = "</span>"

    top = dim + "┌" + "┬".join(["─" * cell_w] * 7) + "┐" + dim_end
    mid = dim + "├" + "┼".join(["─" * cell_w] * 7) + "┤" + dim_end
    bot = dim + "└" + "┴".join(["─" * cell_w] * 7) + "┘" + dim_end

    day_names = ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]
    hdr_cells = [f"<span color='#888888'>{d:^{cell_w}}</span>" for d in day_names]
    hdr = (
        dim
        + "│"
        + dim_end
        + (dim + "│" + dim_end).join(hdr_cells)
        + dim
        + "│"
        + dim_end
    )

    cal_lines.extend([top, hdr, mid])

    month_weeks = cal.monthdayscalendar(year, month)
    for i, week in enumerate(month_weeks):
        week_cells = []
        for day in week:
            if day == 0:
                week_cells.append(" " * cell_w)
            elif day == today_day:
                val = f"{day:>2}"
                week_cells.append(
                    f" <span background='#d90429' color='#ffffff'><b>{val} </b></span> "
                )
            else:
                val = f"{day:>2}"
                week_cells.append(f"<span color='#dcdcdc'>{val:^{cell_w}}</span>")
        row = (
            dim
            + "│"
            + dim_end
            + (dim + "│" + dim_end).join(week_cells)
            + dim
            + "│"
            + dim_end
        )
        cal_lines.append(row)
        if i < len(month_weeks) - 1:
            cal_lines.append(mid)
    cal_lines.append(bot)

    cal_block = "\n".join(cal_lines)

    continent_groups = [
        (
            "AMERICAS",
            "#89b4fa",
            [
                ("Honolulu", "Pacific/Honolulu", "HST"),
                ("Los Angeles", "America/Los_Angeles", "PDT"),
                ("Mexico City", "America/Mexico_City", "CST"),
                ("Chicago", "America/Chicago", "CDT"),
                ("New York", "America/New_York", "EDT"),
                ("São Paulo", "America/Sao_Paulo", "BRT"),
            ],
        ),
        (
            "EUROPE & UTC",
            "#a6e3a1",
            [
                ("UTC", "UTC", "UTC"),
                ("London", "Europe/London", "BST"),
                ("Berlin", "Europe/Berlin", "CEST"),
            ],
        ),
        (
            "AFRICA",
            "#fab387",
            [
                ("Lagos", "Africa/Lagos", "WAT"),
                ("Cairo", "Africa/Cairo", "EEST"),
                ("Johannesburg", "Africa/Johannesburg", "SAST"),
                ("Nairobi", "Africa/Nairobi", "EAT"),
            ],
        ),
        (
            "ASIA & MIDDLE EAST",
            "#cba6f7",
            [
                ("Dubai", "Asia/Dubai", "GST"),
                ("Beijing", "Asia/Shanghai", "CST"),
                ("Seoul", "Asia/Seoul", "KST"),
            ],
        ),
        (
            "OCEANIA",
            "#94e2d5",
            [
                ("Sydney", "Australia/Sydney", "AEST"),
                ("Auckland", "Pacific/Auckland", "NZST"),
            ],
        ),
    ]

    tz_lines = ["\n<b>World Time</b>"]
    for group_name, color, cities in continent_groups:
        for city, tz_str, fallback_code in cities:
            try:
                tz = zoneinfo.ZoneInfo(tz_str)
                local_dt = now_utc.astimezone(tz)
                tz_abbr = local_dt.strftime("%Z")
                if tz_abbr.startswith(("+", "-")):
                    tz_abbr = fallback_code

                city_tz = f"{city} ({tz_abbr})"
                time_str = local_dt.strftime("%I:%M %p")
                date_str = local_dt.strftime("%a, %d %b")

                line = f"<span color='{color}'>{city_tz:<19}</span> <span color='#ffffff'><b>{time_str}</b></span>  <span color='#888888'>({date_str})</span>"
                tz_lines.append(line)
            except Exception:
                continue

    full_tooltip = f"<tt>{cal_block}\n" + "\n".join(tz_lines) + "</tt>"

    output = {"text": bar_text, "tooltip": full_tooltip, "class": "clock"}
    print(json.dumps(output))


if __name__ == "__main__":
    main()
