<?php

namespace local_testmssql\integration;

// @codeCoverageIgnoreStart
defined('MOODLE_INTERNAL') || die();
// @codeCoverageIgnoreEnd

class db_table_not_null_fields_test extends \advanced_testcase
{
    private function db(): \moodle_database
    {
        global $DB;
        return $DB;
    }

    public function test_get_record(): void
    {
        $db = $this->db();
        $id = $db->insert_record('local_testmssql_notnull', (object)[
            'field_int' => 1,
            'field_char' => 'test char',
            'field_text' => 'test text',
        ]);

        $record = $db->get_record('local_testmssql_notnull', ['id' => $id]);
        $this->assertEquals(1, $record->field_int);
        $this->assertEquals('test char', $record->field_char);
        $this->assertEquals('test text', $record->field_text);
    }

    public function test_insert(): void
    {
        $db = $this->db();
        $id = $db->insert_record('local_testmssql_notnull', (object)[
            'field_int' => 1,
            'field_char' => 'test char',
            'field_text' => 'test text',
        ]);
        self::assertTrue($id > 0);
    }

    public function test_update(): void
    {
        $db = $this->db();
        $id = $db->insert_record('local_testmssql_notnull', (object)[
            'field_int' => 1,
            'field_char' => 'test char',
            'field_text' => 'test text',
        ]);

        $record = $db->get_record('local_testmssql_notnull', ['id' => $id]);
        $record->field_int = 2;
        $record->field_char = 'test char 2';
        $record->field_text = 'test text 2';

        $db->update_record('local_testmssql_notnull', $record);

        $record = $db->get_record('local_testmssql_notnull', ['id' => $id]);
        $this->assertEquals(2, $record->field_int);
        $this->assertEquals('test char 2', $record->field_char);
        $this->assertEquals('test text 2', $record->field_text);
    }

    public function test_delete(): void
    {
        $db = $this->db();
        $id = $db->insert_record('local_testmssql_notnull', (object)[
            'field_int' => 1,
            'field_char' => 'test char',
            'field_text' => 'test text',
        ]);

        $record = $db->get_record('local_testmssql_notnull', ['id' => $id]);
        $this->assertNotNull($record);

        $db->delete_records('local_testmssql_notnull', ['id' => $id]);

        $record = $db->get_record('local_testmssql_notnull', ['id' => $id]);
        $this->assertNull($record);
    }
}
