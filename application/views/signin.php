<h3>Hello </h3>

<table>
    <tr>
        <th>Content</th>
    </tr>

    <?php foreach( $this->data  as $row ): ?>
        <tr>
            <td><?php echo 'Hi ' . $row->name; ?></td>
            <td><?php echo 'Your number is ' . $row->phone; ?></td>
        </tr>
    <?php endforeach; ?>

<table>