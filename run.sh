#!/bin/bash
manga_id=1
while true; do
    echo "Trying manga ID: $manga_id"
    
    response=$(curl -s "https://api.jikan.moe/v4/manga/$manga_id")
    
    if ! echo "$response" | grep -q "Not Found"; then
        echo "$response" > /tmp/manga$manga_id.json
        
        psql $DATABASE_URL <<EOF
\set content \`cat /tmp/manga$manga_id.json\`
INSERT INTO manga_data (jsonb) VALUES (:'content'::jsonb);
EOF
        
        echo "Saved manga ID: $manga_id"
    else
        echo "Skipping manga ID: $manga_id (not found)"
    fi
    
    manga_id=$((manga_id + 1))
    sleep 3
done
