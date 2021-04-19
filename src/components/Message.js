import React from "react";
import {Grid} from '@material-ui/core';

export default function Message({ msgItem }) {
    return (
        <Grid container justify="flex-start"  alignItems="center" spacing={3}>
            <Grid key="created-on-grid" style={{ color: 'black' }} item>
                {msgItem.created_on}
            </Grid>
            <Grid key="username-grid" style={{ color: 'brown' }} item>
                {msgItem.name}: 
            </Grid>
            <Grid key="message-content-grid"  style={{ color: 'green' }} item>
                {msgItem.message}
            </Grid>
        </Grid>
  );
}
